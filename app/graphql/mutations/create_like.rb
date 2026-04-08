# frozen_string_literal: true

module Mutations
  class CreateLike < BaseMutation
    description 'Create a like on a likeable object (e.g. post).'

    field :errors, [String], null: false, description: 'Errors that prevented the like from being created.'
    field :like_edge, Types::LikeType.edge_type, null: true, description: 'The likeable object that was liked.'

    argument :likeable_id, ID, loads: Types::LikeableType, required: true,
                               description: 'The ID of the likeable object to like.'

    def authorized?(**_args)
      return true if context[:current_user]

      raise GraphQL::ExecutionError, 'Unauthorized'
    end

    def resolve(likeable:)
      current_user = context[:current_user]
      like = current_user.likes.build(likeable:)

      if like.save
        range_add = GraphQL::Relay::RangeAdd.new(
          parent: current_user,
          collection: current_user.likes,
          item: like,
          context: context
        )

        { like_edge: range_add.edge, errors: [] }
      else
        { like_edge: nil, errors: like.errors.full_messages }
      end
    end
  end
end
