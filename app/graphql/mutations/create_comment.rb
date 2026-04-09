# frozen_string_literal: true

module Mutations
  class CreateComment < BaseMutation
    description 'Create a comment on a commentable object (e.g. post).'

    field :comment_edge, Types::CommentType.edge_type, null: true, description: 'The comment that was created.'
    field :errors, [String], null: false, description: 'Errors that prevented the comment from being created.'

    argument :commentable_id, ID, loads: Types::CommentableType, required: true,
                                  description: 'The ID of the commentable object to comment on.'
    argument :content, String, required: true, description: 'The content of the comment.'

    def authorized?(**_args)
      return true if context[:current_user]

      raise GraphQL::ExecutionError, 'Unauthorized'
    end

    def resolve(commentable:, content:)
      current_user = context[:current_user]
      comment = current_user.comments.build(commentable:, content:)

      if comment.save
        range_add = GraphQL::Relay::RangeAdd.new(
          parent: commentable,
          collection: commentable.comments,
          item: comment,
          context: context
        )

        { comment_edge: range_add.edge, errors: [] }
      else
        { comment_edge: nil, errors: comment.errors.full_messages }
      end
    end
  end
end
