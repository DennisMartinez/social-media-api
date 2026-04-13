# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    description 'The query root of this schema'

    field :groups, Types::GroupType.connection_type, null: false, description: 'A list of all groups.'
    field :viewer, Types::UserType, null: false, description: 'The currently authenticated user'

    def groups
      Group.all
    end

    def viewer
      raise GraphQL::ExecutionError, 'Unauthorized' unless context[:viewer]

      context[:viewer]
    end
  end
end
