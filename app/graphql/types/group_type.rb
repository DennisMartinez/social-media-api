# frozen_string_literal: true

module Types
  class GroupType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    description 'A group that users can join and post in.'

    field :avatar_url, String, null: true, description: 'The URL of the group\'s avatar image.'
    field :bio, String, null: true, description: 'A short description of the group.'
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The date and time when the group was created.'
    field :member_count, Integer, null: false, description: 'The number of members in the group.'
    field :members, Types::UserType.connection_type, null: true, description: 'The users who are members of the group.'
    field :name, String, null: false, description: 'The name of the group.'
    field :owner, Types::UserType, null: false, description: 'The user who created the group.'
    field :post_count, Integer, null: false, description: 'The number of posts in the group.'
    field :posts, Types::PostType.connection_type, null: true, description: 'The posts that have been made in the group.'
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The date and time when the group was last updated.'
    field :viewer_can_join, Boolean, null: false, description: 'Whether the current viewer can join the group.'
    field :viewer_can_leave, Boolean, null: false, description: 'Whether the current viewer can leave the group.'
    field :viewer_is_member, Boolean, null: false, description: 'Whether the current viewer is a member of the group.'

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

    def owner
      dataloader.with(Sources::RecordSource, User).load(object.owner_id)
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

    def viewer_can_join
      viewer_is_member.then(&:!)
    end

    def viewer_can_leave
      viewer_is_member
    end

    def viewer_is_member
      dataloader.with(Sources::AssociationSource, :members).load(object).then do |members|
        members.any? { |member| member.id == context[:viewer].id }
      end
    end
  end
end
