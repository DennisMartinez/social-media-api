class Sources::FeedSource < GraphQL::Dataloader::Source
  def fetch(users)
    user_ids = users.flat_map { |u| [u.id] + u.following_ids }.uniq
    posts = Post.where(user_id: user_ids)
                .order(created_at: :desc)
                .group_by(&:user_id)

    users.map do |user|
      relevant_ids = [user.id] + user.following_ids
      relevant_ids.flat_map { |id| posts[id] || [] }
                  .sort_by { |p| -p.created_at.to_i }
    end
  end
end
