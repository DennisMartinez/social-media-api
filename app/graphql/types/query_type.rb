# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'The query root of this schema'

    field :current_user, UserType, null: false, description: 'The currently authenticated user.'
    field :users_to_follow, UserType.connection_type, null: false,
                                                      description: 'A list of users that the current user can follow.'

    # TODO: Get this working
    def authorized?
      return true if context[:current_user]

      raise GraphQL::ExecutionError, 'Unauthorized'
    end

    def current_user
      context[:current_user]
    end

    def users_to_follow
      User.where.not(id: current_user.id)
      # .where.not(id: current_user.following.select(:id))
      # .order('RANDOM()')
    end
  end
end
