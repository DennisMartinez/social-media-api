# frozen_string_literal: true

module Mutations
  class SignUp < BaseMutation
    description 'Sign up a new user by creating a user account with the provided email, name, and password.'

    field :current_user, Types::UserType, null: true, description: 'The newly created user account.'
    field :errors, [String], null: false, description: 'Any errors that occurred during sign up.'

    argument :email, String, required: true, description: 'The email address of the user.'
    argument :name, String, required: true, description: 'The name of the user.'
    argument :password, String, required: true, description: 'The password for the user account.'

    def resolve(name:, email:, password:)
      user = User.new(name:, email:, password:)

      if user.save
        { current_user: user, errors: [] }
      else
        { current_user: nil, errors: user.errors.full_messages }
      end
    end
  end
end
