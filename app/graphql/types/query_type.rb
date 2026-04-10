# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    description 'The query root of this schema'

    field :viewer, UserType, null: false, description: 'The currently authenticated user'

    def viewer
      raise GraphQL::ExecutionError, 'Unauthorized' unless context[:viewer]

      context[:viewer]
    end
  end
end
