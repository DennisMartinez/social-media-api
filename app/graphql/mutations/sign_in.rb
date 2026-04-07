# frozen_string_literal: true

module Mutations
  class SignIn < BaseMutation
    description 'Sign in a user and create a session for them.'

    field :current_user, Types::UserType, null: true, description: 'The currently signed-in user.'
    field :errors, [String], null: false, description: 'Any errors that occurred during sign in.'

    argument :email, String, required: true, description: 'The email address of the user.'
    argument :password, String, required: true, description: 'The password for the user account.'

    def resolve(email:, password:)
      if (user = User.authenticate_by(email:, password:))
        context[:application_controller].start_new_session_for(user)
        { current_user: user, errors: [] }
      else
        { current_user: nil, errors: ['Invalid email or password'] }
      end
    end
  end
end
