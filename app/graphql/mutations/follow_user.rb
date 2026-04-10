# frozen_string_literal: true

module Mutations
  class FollowUser < BaseMutation
    description 'Follow a user.'

    field :errors, [String], null: false, description: 'Any errors that occurred while trying to follow the user.'
    field :followed_user, Types::UserType, null: true, description: 'The user that was followed.'
    field :viewer, Types::UserType, null: true, description: 'The user that is performing the follow action.'

    argument :user_id, ID, required: true, loads: Types::UserType, description: 'The ID of the user to follow.'

    def authorized?(**_args)
      return true if context[:viewer]

      raise GraphQL::ExecutionError, 'Unauthorized'
    end

    def resolve(user:)
      viewer = context[:viewer]

      if viewer.follow(user)
        { viewer:, followed_user: user, errors: [] }
      else
        { viewer:, followed_user: nil, errors: ['Failed to follow the user'] }
      end
    end
  end
end
