# frozen_string_literal: true

module Mutations
  class FollowUser < BaseMutation
    description 'Follow a user.'

    field :current_user, Types::UserType, null: true, description: 'The user that is performing the follow action.'
    field :errors, [String], null: false, description: 'Any errors that occurred while trying to follow the user.'
    field :followed_user, Types::UserType, null: true, description: 'The user that was followed.'

    argument :user_id, ID, required: true, loads: Types::UserType, description: 'The ID of the user to follow.'

    def authorized?(**_args)
      return true if context[:current_user]

      raise GraphQL::ExecutionError, 'Unauthorized'
    end

    def resolve(user:)
      current_user = context[:current_user]

      if current_user.id == user.id
        return { current_user: nil, followed_user: nil, errors: ['You cannot follow yourself'] }
      end

      if current_user.following.exists?(user.id)
        return { current_user: nil, followed_user: nil, errors: ['You are already following this user'] }
      end

      current_user.following << user

      { current_user:, followed_user: user, errors: [] }
    end
  end
end
