# frozen_string_literal: true

module Types
  class LikeType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    description 'A like made by a user on a likeable object (e.g. post).'

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The time when the like was created.'
    field :likeable, Types::LikeableType, null: false, description: 'The object that was liked.'
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false,
                                                        description: 'The time when the like was last updated.'
    field :user, Types::UserType, null: false, description: 'The user who created the like.'
  end
end
