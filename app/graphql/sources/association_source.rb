class Sources::AssociationSource < GraphQL::Dataloader::Source
  def initialize(association_name, order: nil)
    @association_name = association_name
    @order = order # e.g. { created_at: :desc } — a plain Hash, not an AR relation
  end

  def fetch(records)
    reflection = records.first.class.reflect_on_association(@association_name)

    if reflection.options[:as]
      poly_name        = reflection.options[:as].to_s
      foreign_key_id   = "#{poly_name}_id"
      foreign_key_type = "#{poly_name}_type"
      record_type      = records.first.class.name
      klass            = reflection.klass

      base = klass.where(foreign_key_type => record_type, foreign_key_id => records.map(&:id))
      base = base.order(@order) if @order
      base.group_by { |r| r.public_send(foreign_key_id) }
          .then { |results| records.map { |r| results[r.id] || [] } }
    else
      ActiveRecord::Associations::Preloader.new(
        records: records,
        associations: @association_name,
        scope: @order ? records.first.class.reflect_on_association(@association_name).klass.order(@order) : nil
      ).call

      records.map { |r| r.public_send(@association_name).to_a }
    end
  end
end
