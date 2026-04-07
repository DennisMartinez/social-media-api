# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description 'The mutation root of this schema'

    field :sign_in, mutation: Mutations::SignIn, description: 'Sign in a user with their email and password.'
    field :sign_out, mutation: Mutations::SignOut, description: 'Sign out the currently authenticated user.'
    field :sign_up, mutation: Mutations::SignUp,
                    description: 'Create a new user account with the provided email, name, and password.'
  end
end
