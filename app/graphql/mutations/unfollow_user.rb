# frozen_string_literal: true

module Mutations
  class UnfollowUser < BaseMutation
    description 'Unfollow a user.'

    field :current_user, Types::UserType, null: true, description: 'The user that is performing the unfollow action.'
    field :errors, [String], null: false, description: 'Any errors that occurred while trying to unfollow the user.'
    field :unfollowed_user, Types::UserType, null: false, description: 'The user that was unfollowed.'

    argument :user_id, ID, required: true, loads: Types::UserType, description: 'The ID of the user to unfollow.'

    def authorized?(**_args)
      return true if context[:current_user]

      raise GraphQL::ExecutionError, 'Unauthorized'
    end

    def resolve(user:)
      current_user = context[:current_user]

      if current_user.id == user.id
        return { current_user:, unfollowed_user: nil, errors: ['You cannot unfollow yourself'] }
      end

      unless current_user.following.exists?(user.id)
        return { current_user:, unfollowed_user: nil, errors: ['You are not following this user'] }
      end

      if current_user.following.destroy(user)
        { current_user:, unfollowed_user: user, errors: [] }
      else
        { current_user:, unfollowed_user: nil, errors: ['Failed to unfollow the user'] }
      end
    end
  end
end
