# frozen_string_literal: true

module Mutations
  class FollowUser < BaseMutation
    description 'Follow a user.'

    field :errors, [String], null: false, description: 'Any errors that occurred while trying to follow the user.'
    field :followee, Types::UserType, null: true, description: 'The user that was followed.'
    field :follower, Types::UserType, null: true, description: 'The user that is following.'

    argument :user_id, ID, required: true, loads: Types::UserType, description: 'The ID of the user to follow.'

    def authorized?(**_args)
      return true if context[:viewer]

      raise GraphQL::ExecutionError, 'Unauthorized'
    end

    def resolve(user:)
      viewer = context[:viewer]

      if viewer.follow(user)
        { follower: viewer, followee: user, errors: [] }
      else
        { follower: viewer, followee: nil, errors: ['Failed to follow the user'] }
      end
    end
  end
end
