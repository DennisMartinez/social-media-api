# frozen_string_literal: true

module Mutations
  class DestroyPost < BaseMutation
    description 'Deletes a post created by the current user.'

    field :errors, [String], null: false, description: 'Errors that prevented the post from being deleted.'
    field :post, Types::PostType, null: true, description: 'The post that was deleted.'

    argument :post_id, ID, required: true, loads: Types::PostType, description: 'The ID of the post to delete.'

    def authorized?(post:, **_args)
      return true if context[:current_user] && post.user_id == context[:current_user].id

      raise GraphQL::ExecutionError, 'Unauthorized'
    end

    def resolve(post:)
      if post.destroy
        { post:, errors: [] }
      else
        { post: nil, errors: post.errors.full_messages }
      end
    end
  end
end
