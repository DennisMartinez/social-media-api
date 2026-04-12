# frozen_string_literal: true

module Mutations
  class UnfollowUser < BaseMutation
    description 'Unfollow a user.'

    field :errors, [String], null: false, description: 'Any errors that occurred while trying to unfollow the user.'
    field :followee, Types::UserType, null: true, description: 'The user that was unfollowed.'
    field :follower, Types::UserType, null: true, description: 'The user that is unfollowing.'

    argument :user_id, ID, required: true, loads: Types::UserType, description: 'The ID of the user to unfollow.'

    def authorized?(**_args)
      return true if context[:viewer]

      raise GraphQL::ExecutionError, 'Unauthorized'
    end

    def resolve(user:)
      viewer = context[:viewer]

      if viewer.unfollow(user)
        { follower: viewer, followee: user, errors: [] }
      else
        { follower: viewer, followee: nil, errors: ['Failed to unfollow the user'] }
      end
    end
  end
end
