# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    description 'A user of the social media platform.'

    field :avatar_url, String, null: true, description: 'The URL of the user\'s avatar image.'
    field :comments, Types::CommentType.connection_type, null: true, description: 'The comments made by the user.'
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The time when the user was created.'
    field :email, String, null: false, description: 'The email address of the user.'
    field :feed, Types::PostType.connection_type,
          null: false, description: 'The feed of posts from the current user and the users they follow.'
    field :follower_count, Integer, null: false, description: 'The number of followers this user has.'
    field :followers, Types::UserType.connection_type, null: true, description: 'The users who are following this user.'
    field :following, Types::UserType.connection_type, null: true, description: 'The users that this user is following.'
    field :following_count, Integer, null: false, description: 'The number of users this user is following.'
    field :likes, Types::LikeType.connection_type, null: true, description: 'The likes made by the user.'
    field :name, String, null: false, description: 'The name of the user.'
    field :posts, Types::PostType.connection_type, null: true, description: 'The posts created by the user.'
    field :recommended_follows, Types::UserType.connection_type,
          null: true, description: 'Recommended users to follow based on the user\'s following list.'
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false,
                                                        description: 'The time when the user was last updated.'
    field :viewer_can_follow, Boolean, null: false,
                                       description: 'Whether the current viewer can follow this user.'
    field :viewer_is_following, Boolean, null: false, description: 'Whether the current viewer is following this user.'

    def avatar_url
      dataloader.with(Sources::ActiveStorageUrlSource, :avatar).load(object)
    end

    def viewer_can_follow
      return false unless context[:viewer]
      return false if context[:viewer] == object

      true
    end

    def posts
      dataloader
        .with(Sources::AssociationSource, :posts, order: { created_at: :desc })
        .load(object)
    end

    def followers
      dataloader
        .with(Sources::AssociationSource, :followers, order: { created_at: :desc })
        .load(object)
    end

    def follower_count
      dataloader
        .with(Sources::AssociationSource, :followers)
        .load(object)
        .then(&:length)
    end

    def following
      dataloader
        .with(Sources::AssociationSource, :following, order: { created_at: :desc })
        .load(object)
    end

    def following_count
      dataloader
        .with(Sources::AssociationSource, :following)
        .load(object)
        .then(&:length)
    end

    def comments
      dataloader
        .with(Sources::AssociationSource, :comments, order: { created_at: :desc })
        .load(object)
    end

    def likes
      dataloader
        .with(Sources::AssociationSource, :likes, order: { created_at: :desc })
        .load(object)
    end

    def feed
      dataloader.with(Sources::FeedSource).load(object)
    end

    def recommended_follows
      dataloader.with(Sources::RecommendedFollowsSource, context[:viewer]).load(object)
    end

    def viewer_is_following
      dataloader.with(Sources::FollowingCheckSource, context[:viewer]).load(object)
    end
  end
end
