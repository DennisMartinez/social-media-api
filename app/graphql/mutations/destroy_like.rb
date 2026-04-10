# frozen_string_literal: true

module Mutations
  class DestroyLike < BaseMutation
    description 'Destroy a like on a likeable object (e.g. post).'

    field :errors, [String], null: false, description: 'Errors that prevented the like from being destroyed.'
    field :like, Types::LikeType, null: true, description: 'The like that was destroyed.'

    argument :likeable_id, ID, loads: Types::LikeableType, required: true,
                               description: 'The ID of the likeable object to unlike.'

    def authorized?(likeable:, **_args)
      viewer = context[:viewer]
      like = viewer.likes.find_by(likeable:)

      return true if like

      raise GraphQL::ExecutionError, 'Unauthorized'
    end

    def resolve(likeable:)
      viewer = context[:viewer]
      like = viewer.likes.find_by(likeable:)

      if like.destroy
        { like:, errors: [] }
      else
        { like: nil, errors: like.errors.full_messages }
      end
    end
  end
end
