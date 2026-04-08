# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    description 'A user of the social media platform.'

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The time when the user was created.'
    field :email, String, null: false, description: 'The email address of the user.'
    field :name, String, null: false, description: 'The name of the user.'
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false,
                                                        description: 'The time when the user was last updated.'

    field :feed, Types::PostType.connection_type,
          null: false, description: 'The feed of posts from the current user and the users they follow.'
    field :is_following, Boolean, null: false, description: 'Whether the current user is following this user.'
    field :posts, Types::PostType.connection_type, null: true, description: 'The posts created by the user.'
    field :recommended_follows, Types::UserType.connection_type, null: false,
                                                                 description: 'Recommended users to follow based on the user\'s following list.'

    # TODO: Rename to be more clear that is following uses current user
    def is_following
      context[:current_user].following?(object)
    end

    def feed
      Post.where(user_id: [object.id] + object.following_ids)
    end

    def recommended_follows
      User.all
      # User.where.not(id: [object.id] + object.following_ids).order('RANDOM()')
    end
  end
end
