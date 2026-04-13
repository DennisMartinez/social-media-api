# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description 'The mutation root of this schema'

    field :create_comment, mutation: Mutations::CreateComment,
                           description: 'Create a comment on a commentable object (e.g. post).'
    field :create_like, mutation: Mutations::CreateLike, description: 'Create a like on a likeable object (e.g. post).'
    field :create_password_reset_token,
          mutation: Mutations::CreatePasswordResetToken,
          description: 'Initiate the password reset process by sending a reset token to the user\'s email address.'
    field :create_post, mutation: Mutations::CreatePost, description: 'Create a new post for the current user.'
    field :destroy_comment, mutation: Mutations::DestroyComment,
                            description: 'Delete a comment created by the current user.'
    field :destroy_like, mutation: Mutations::DestroyLike,
                         description: 'Destroy a like on a likeable object (e.g. post).'
    field :destroy_post, mutation: Mutations::DestroyPost, description: 'Delete a post created by the current user.'
    field :follow_user, mutation: Mutations::FollowUser, description: 'Follow a user.'
    field :join_group, mutation: Mutations::JoinGroup, description: 'Join a group.'
    field :leave_group, mutation: Mutations::LeaveGroup, description: 'Leave a group.'
    field :sign_in, mutation: Mutations::SignIn, description: 'Sign in a user with their email and password.'
    field :sign_out, mutation: Mutations::SignOut, description: 'Sign out the currently authenticated user.'
    field :sign_up, mutation: Mutations::SignUp,
                    description: 'Create a new user account with the provided email, name, and password.'
    field :unfollow_user, mutation: Mutations::UnfollowUser, description: 'Unfollow a user.'
    field :update_password_with_reset_token, mutation: Mutations::UpdatePasswordWithResetToken,
                                             description: 'Update a user\'s password using a valid reset token.'
  end
end
