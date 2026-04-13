# frozen_string_literal: true

module Mutations
  class CreatePost < BaseMutation
    description 'Creates a new post for the current user.'

    field :errors, [String], null: false, description: 'Errors that prevented the post from being created.'
    field :post_edge, Types::PostType.edge_type, null: true, description: 'The post that was created.'

    argument :content, String, required: true, description: 'The content of the post.'
    argument :group_id, ID, loads: Types::GroupType, required: false, description: 'The ID of the group to post in (optional).'

    def authorized?(group: nil, **_args)
      return true if context[:viewer]

      if group.present?
        return true if group.members.exists?(user_id: context[:viewer].id)

        raise GraphQL::ExecutionError, 'You must be a member of the group to post in it.'
      end

      raise GraphQL::ExecutionError, 'Authentication required'
    end

    def resolve(content:, group: nil)
      viewer = context[:viewer]
      post = viewer.posts.build(content:, group:)

      if post.save
        range_add = GraphQL::Relay::RangeAdd.new(
          parent: viewer,
          collection: viewer.posts,
          item: post,
          context: context
        )

        { post_edge: range_add.edge, errors: [] }
      else
        { post_edge: nil, errors: post.errors.full_messages }
      end
    end
  end
end
