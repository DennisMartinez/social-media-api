# frozen_string_literal: true

module Sources
  class AssociationSource < GraphQL::Dataloader::Source
    def initialize(association_name, order: nil)
      @association_name = association_name
      @order = order # e.g. { created_at: :desc } — a plain Hash, not an AR relation
    end

    def fetch(records)
      reflection = records.first.class.reflect_on_association(@association_name)

      if reflection.options[:as]
        poly_name = reflection.options[:as].to_s
        foreign_key_id = "#{poly_name}_id"
        foreign_key_type = "#{poly_name}_type"
        record_type = records.first.class.name
        klass = reflection.klass

        conn = klass.connection
        safe_type_col = conn.quote_column_name(foreign_key_type)
        safe_id_col   = conn.quote_column_name(foreign_key_id)

        base = klass.where(
          "#{safe_type_col} = ? AND #{safe_id_col} IN (?)",
          record_type,
          records.map(&:id)
        )
        base = base.order(@order) if @order
        base.group_by { |r| r.public_send(foreign_key_id) }.then { |results| records.map { |r| results[r.id] || [] } }
      else
        ActiveRecord::Associations::Preloader.new(
          records: records,
          associations: @association_name,
          scope: @order ? records.first.class.reflect_on_association(@association_name).klass.order(@order) : nil
        ).call

        records.map do |r|
          association = r.public_send(@association_name)

          reflection.collection? ? association.to_a : association
        end
      end
    end
  end
end
