# frozen_string_literal: true

module Mutations
  class CreatePasswordResetToken < BaseMutation
    description 'Initiate the password reset process by sending a reset token to the user\'s email address.'

    field :errors, [String], null: false,
                             description: 'Any errors that occurred during the password reset token creation.'
    field :success, Boolean, null: false, description: 'Whether the password reset token was successfully created.'

    argument :email, String, required: true, description: 'The email address of the user requesting a password reset.'

    def resolve(email:)
      if (user = User.find_by(email:))
        PasswordsMailer.reset(user).deliver_later
      end

      { success: true, errors: [] }
    end
  end
end
