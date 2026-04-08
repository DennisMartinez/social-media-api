# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    description 'The query root of this schema'

    field :current_user, UserType, null: false, description: 'The currently authenticated user.'

    def current_user
      raise GraphQL::ExecutionError, 'Unauthorized' if context[:current_user].blank?

      context[:current_user]
    end
  end
end
