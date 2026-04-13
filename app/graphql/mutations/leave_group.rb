# frozen_string_literal: true

module Mutations
  class LeaveGroup < BaseMutation
    description 'Leave a group.'

    field :errors, [String], null: false, description: 'Any errors that occurred while trying to leave the group.'
    field :group, Types::GroupType, null: true, description: 'The group that was left.'
    field :user, Types::UserType, null: true, description: 'The user that left the group.'

    argument :group_id, ID, required: true, loads: Types::GroupType, description: 'The ID of the group to leave.'

    def authorized?(**_args)
      return true if context[:viewer]

      raise GraphQL::ExecutionError, 'Unauthorized'
    end

    def resolve(group:)
      viewer = context[:viewer]

      if group.members.exclude?(viewer)
        { group: nil, user: nil, errors: ['You are not a member of this group'] }
      elsif group.members.delete(viewer)
        { group:, user: viewer, errors: [] }
      else
        { group: nil, user: nil, errors: ['Failed to leave the group'] }
      end
    end
  end
end
