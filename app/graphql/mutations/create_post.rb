# frozen_string_literal: true

module Mutations
  class CreatePost < BaseMutation
    description 'Creates a new post for the current user.'

    field :errors, [String], null: false, description: 'Errors that prevented the post from being created.'
    field :post_edge, Types::PostType.edge_type, null: true, description: 'The post that was created.'

    argument :content, String, required: true, description: 'The content of the post.'

    def authorized?(**_args)
      return true if context[:current_user]

      raise GraphQL::ExecutionError, 'Authentication required'
    end

    def resolve(content:)
      post = context[:current_user].posts.build(content: content)

      if post.save
        range_add = GraphQL::Relay::RangeAdd.new(
          parent: post,
          collection: context[:current_user].posts,
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
