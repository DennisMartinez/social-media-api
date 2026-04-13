# frozen_string_literal: true

module Mutations
  class JoinGroup < BaseMutation
    description 'Join a group.'

    field :errors, [String], null: false, description: 'Any errors that occurred while trying to join the group.'
    field :group, Types::GroupType, null: true, description: 'The group that was joined.'
    field :user, Types::UserType, null: true, description: 'The user that joined the group.'

    argument :group_id, ID, required: true, loads: Types::GroupType, description: 'The ID of the group to join.'

    def authorized?(**_args)
      return true if context[:viewer]

      raise GraphQL::ExecutionError, 'Unauthorized'
    end

    def resolve(group:)
      viewer = context[:viewer]

      if group.members.include?(viewer)
        { group: nil, user: nil, errors: ['You are already a member of this group'] }
      elsif group.members << viewer
        { group:, user: viewer, errors: [] }
      else
        { group: nil, user: nil, errors: ['Failed to join the group'] }
      end
    end
  end
end
