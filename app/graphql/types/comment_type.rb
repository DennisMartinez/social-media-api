# frozen_string_literal: true

module Types
  class CommentType < Types::BaseObject
    implements GraphQL::Types::Relay::Node

    description 'A comment made by a user on a commentable object (e.g. post).'

    field :commentable, Types::CommentableType, null: false, description: 'The object that was commented on.'
    field :content, String, null: false, description: 'The content of the comment.'
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false,
                                                        description: 'The time when the comment was created.'
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false,
                                                        description: 'The time when the comment was last updated.'
    field :user, Types::UserType, null: false, description: 'The user who created the comment.'
  end
end
