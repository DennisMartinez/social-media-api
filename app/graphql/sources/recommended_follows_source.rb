class Sources::RecommendedFollowsSource < GraphQL::Dataloader::Source
  def initialize(viewer)
    @viewer = viewer
  end

  def fetch(users)
    all_excluded_ids = users.flat_map { |u| [u.id, @viewer.id] + u.following_ids }.uniq
    candidates = User.where.not(id: all_excluded_ids).order('RANDOM()').limit(50)

    users.map do |user|
      excluded = Set.new([user.id] + user.following_ids)
      candidates.reject { |c| excluded.include?(c.id) }
    end
  end
end
