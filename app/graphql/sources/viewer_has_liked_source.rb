class Sources::ViewerHasLikedSource < GraphQL::Dataloader::Source
  def initialize(viewer)
    @viewer = viewer
  end

  def fetch(likeables)
    return likeables.map { false } unless @viewer

    liked_ids = @viewer.likes
                       .where(likeable: likeables)
                       .pluck(:likeable_id, :likeable_type)
                       .each_with_object(Set.new) { |(id, type), set| set << [id, type] }

    likeables.map { |l| liked_ids.include?([l.id, l.class.name]) }
  end
end
