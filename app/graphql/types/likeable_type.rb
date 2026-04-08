# frozen_string_literal: true

module Types
  class LikeableType < Types::BaseUnion
    description 'Objects that can be liked.'
    possible_types Types::PostType

    def self.resolve_type(object, _context)
      case object
      when Post
        Types::PostType
      else
        raise "Unexpected likeable type: #{object.class.name}"
      end
    end
  end
end
