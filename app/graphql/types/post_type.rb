# frozen_string_literal: true

module Types
  class PostType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    field :content, String, null: false, description: 'The content of the post.'
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false, description: 'The time when the post was created.'
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false,
                                                        description: 'The time when the post was last updated.'
    field :user, Types::UserType, null: false, description: 'The user who created the post.'
  end
end
