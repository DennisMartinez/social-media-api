# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    description 'A post created by a user.'

    field :can_destroy, Boolean, null: false, description: 'Whether the current user can destroy this post.'
    field :content, String, null: false, description: 'The content of the post.'
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The time when the post was created.'
    field :is_liked_by_current_user, Boolean, null: false, description: 'Whether the current user has liked this post.'
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false,
                                                        description: 'The time when the post was last updated.'
    field :user, Types::UserType, null: false, description: 'The user who created the post.'

    field :current_user_like, Types::LikeType, null: true,
                                               description: 'The like that the current user has on this post, if it exists.'

    def can_destroy
      # TODO: Replace with pundit
      object.can_destroy?(context[:current_user])
    end

    def is_liked_by_current_user
      context[:current_user].liked_posts.exists?(id: object.id)
    end
  end
end
