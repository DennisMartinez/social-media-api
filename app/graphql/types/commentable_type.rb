# frozen_string_literal: true

module Types
  class CommentableType < Types::BaseUnion
    description 'Objects that can be commented on.'

    possible_types Types::PostType

    def self.resolve_type(object, _context)
      case object
      when Post
        Types::PostType
      else
        raise "Unexpected commentable type: #{object.class.name}"
      end
    end
  end
end
