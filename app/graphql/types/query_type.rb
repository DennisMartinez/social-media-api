# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'The query root of this schema'

    field :current_user, UserType, null: true, description: 'The currently authenticated user.'
    def current_user
      raise GraphQL::ExecutionError, 'Unauthorized' unless context[:current_user]

      context[:current_user]
    end
  end
end
