# frozen_string_literal: true

module Mutations
  class SignUp < BaseMutation
    description 'Sign up a new user by creating a user account with the provided email, name, and password.'

    field :errors, [String], null: false, description: 'Any errors that occurred during sign up.'
    field :viewer, Types::UserType, null: true, description: 'The newly created user account.'

    argument :email, String, required: true, description: 'The email address of the user.'
    argument :name, String, required: true, description: 'The name of the user.'
    argument :password, String, required: true, description: 'The password for the user account.'

    def resolve(name:, email:, password:)
      user = User.new(name:, email:, password:)

      if user.save
        { viewer: user, errors: [] }
      else
        { viewer: nil, errors: user.errors.full_messages }
      end
    end
  end
end
