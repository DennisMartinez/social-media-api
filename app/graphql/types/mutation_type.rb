# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description 'The mutation root of this schema'

    field :create_password_reset_token,
          mutation: Mutations::CreatePasswordResetToken,
          description: 'Initiate the password reset process by sending a reset token to the user\'s email address.'
    field :sign_in, mutation: Mutations::SignIn, description: 'Sign in a user with their email and password.'
    field :sign_out, mutation: Mutations::SignOut, description: 'Sign out the currently authenticated user.'
    field :sign_up, mutation: Mutations::SignUp,
                    description: 'Create a new user account with the provided email, name, and password.'
    field :update_password_with_reset_token, mutation: Mutations::UpdatePasswordWithResetToken,
                                             description: 'Update a user\'s password using a valid reset token.'
  end
end
