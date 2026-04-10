# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    description 'A post created by a user.'

    field :comments, Types::CommentType.connection_type, null: false, description: 'The comments on this post.'
    field :comments_count, Integer, null: false, description: 'The number of comments on this post.'
    field :content, String, null: false, description: 'The content of the post.'
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The time when the post was created.'

    field :likes, Types::LikeType.connection_type, null: false, description: 'The likes on this post.'
    field :likes_count, Integer, null: false, description: 'The number of likes on this post.'
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false,
                                                        description: 'The time when the post was last updated.'
    field :user, Types::UserType, null: false, description: 'The user who created the post.'
    field :viewer_can_destroy, Boolean, null: false, description: 'Whether the current viewer can destroy this post.'
    field :viewer_can_like, Boolean, null: false, description: 'Whether the current viewer can like this post.'
    field :viewer_has_liked, Boolean, null: false, description: 'Whether the current viewer is liking this post.'

    def comments
      object.comments.order(created_at: :desc)
    end

    def likes
      object.likes.order(created_at: :desc)
    end

    def viewer_can_destroy
      # TODO: Replace with pundit
      object.can_destroy?(context[:viewer])
    end

    def viewer_can_like
      return false unless context[:viewer]
      return false if context[:viewer] == object.user

      true
    end

    def viewer_has_liked
      context[:viewer].likes.exists?(likeable: object)
    end
  end
end
