# frozen_string_literal: true

module Mutations
  class DestroyComment < BaseMutation
    description 'Destroy a comment on a commentable object (e.g. post).'

    field :comment, Types::CommentType, null: true, description: 'The comment that was destroyed.'
    field :errors, [String], null: false, description: 'Errors that prevented the comment from being destroyed.'

    argument :comment_id, ID, loads: Types::CommentType, required: true,
                              description: 'The ID of the comment to destroy.'

    def authorized?(comment:, **_args)
      current_user = context[:current_user]

      return true if comment.user_id == current_user.id

      raise GraphQL::ExecutionError, 'Unauthorized'
    end

    def resolve(comment:)
      if comment.destroy
        { comment:, errors: [] }
      else
        { comment: nil, errors: comment.errors.full_messages }
      end
    end
  end
end
