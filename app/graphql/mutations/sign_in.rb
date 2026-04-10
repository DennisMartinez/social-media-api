# frozen_string_literal: true

module Mutations
  class SignIn < BaseMutation
    description 'Sign in a user and create a session for them.'

    field :errors, [String], null: false, description: 'Any errors that occurred during sign in.'
    field :viewer, Types::UserType, null: true, description: 'The currently signed-in user.'

    argument :email, String, required: true, description: 'The email address of the user.'
    argument :password, String, required: true, description: 'The password for the user account.'

    def resolve(email:, password:)
      if (user = User.authenticate_by(email:, password:))
        context[:application_controller].start_new_session_for(user)
        { viewer: user, errors: [] }
      else
        { viewer: nil, errors: ['Invalid email or password'] }
      end
    end
  end
end
