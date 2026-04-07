# frozen_string_literal: true

module Mutations
  class UpdatePasswordWithResetToken < BaseMutation
    description 'Update a user\'s password using a password reset token sent to their email address.'

    field :errors, [String], null: false, description: 'Any errors that occurred during the password update process.'
    field :success, Boolean, null: false, description: 'Whether the password was successfully updated.'

    argument :password, String, required: true, description: 'The new password to set for the user account.'
    argument :password_confirmation, String, required: true, description: 'Confirmation of the new password.'
    argument :reset_token, String, required: true, description: 'The password reset token sent to the user\'s email.'

    def resolve(reset_token:, password:, password_confirmation:)
      @user = User.find_by_password_reset_token(reset_token) # rubocop:disable Rails/DynamicFindBy

      return { success: true, errors: [] } if @user.update(password:, password_confirmation:)

      { success: false, errors: @user.errors.full_messages }
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      { success: false, errors: ['Password reset link is invalid or has expired.'] }
    end
  end
end
