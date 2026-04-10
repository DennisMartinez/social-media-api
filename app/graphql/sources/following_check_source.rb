class Sources::FollowingCheckSource < GraphQL::Dataloader::Source
  def initialize(viewer)
    @viewer = viewer
  end

  def fetch(targets)
    return targets.map { false } unless @viewer

    following_ids = Set.new(@viewer.following_ids)
    targets.map { |t| following_ids.include?(t.id) }
  end
end
