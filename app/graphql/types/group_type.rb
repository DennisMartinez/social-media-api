# frozen_string_literal: true

module Types
  class GroupType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    description 'A group that users can join and post in.'

    field :avatar_url, String, null: true, description: 'The URL of the group\'s avatar image.'
    field :bio, String, null: true, description: 'A short description of the group.'
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false,
                                                        description: 'The date and time when the group was created.'
    field :id, ID, null: false, description: 'The unique identifier of the group.'
    field :member_count, Integer, null: false, description: 'The number of members in the group.'
    field :members, [Types::UserType], null: false, description: 'The users who are members of the group.'
    field :name, String, null: false, description: 'The name of the group.'
    field :post_count, Integer, null: false, description: 'The number of posts in the group.'
    field :posts, [Types::PostType], null: false, description: 'The posts that have been made in the group.'
    field :updated_at, GraphQL::Types::ISO8601DateTime,
          null: false, description: 'The date and time when the group was last updated.'

    def avatar_url
      dataloader.with(Sources::ActiveStorageUrlSource, :avatar).load(object)
    end

    def members
      dataloader.with(Sources::AssociationSource, :members).load(object)
    end

    def member_count
      dataloader
        .with(Sources::AssociationSource, :members)
        .load(object)
        .then(&:length)
    end

    def posts
      dataloader.with(Sources::AssociationSource, :posts).load(object)
    end

    def post_count
      dataloader
        .with(Sources::AssociationSource, :posts)
        .load(object)
        .then(&:length)
    end
  end
end
