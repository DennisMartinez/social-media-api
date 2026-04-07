# frozen_string_literal: true

module Mutations
  class SignOut < BaseMutation
    description 'Sign out the current user by deleting their session.'

    field :errors, [String], null: false, description: 'Any errors that occurred during sign out.'
    field :success, Boolean, null: false, description: 'Whether the sign out was successful.'

    def resolve
      context[:application_controller].terminate_session
      { success: true, errors: [] }
    rescue StandardError
      { success: false, errors: ['No user signed in'] }
    end
  end
end
