# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The time when the user was created.'
    field :email, String, null: false, description: 'The email address of the user.'
    field :name, String, null: false, description: 'The name of the user.'
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false,
                                                        description: 'The time when the user was last updated.'
  end
end
