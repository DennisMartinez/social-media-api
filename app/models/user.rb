# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  bio             :text(1000)
#  email           :string(255)      not null
#  name            :string(255)      not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_secure_password

  has_one_attached :avatar

  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :likeable, source_type: 'Post'

  has_many :comments, dependent: :destroy
  has_many :commented_posts, through: :comments, source: :commentable, source_type: 'Post'

  has_many :following_relationships, class_name: 'Follow', foreign_key: 'follower_id', inverse_of: :follower,
                                     dependent: :destroy
  has_many :following, through: :following_relationships, source: :followed
  has_many :follower_relationships, class_name: 'Follow', foreign_key: 'followed_id', inverse_of: :followed,
                                    dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :group_memberships, dependent: :destroy
  has_many :groups, through: :group_memberships
  has_many :owned_groups, class_name: 'Group', foreign_key: 'owner_id', inverse_of: :owner, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :bio, length: { maximum: 1000 }, allow_blank: true
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :password, presence: true, if: -> { new_record? || password.present? }

  normalizes :email, with: ->(e) { e.strip.downcase }

  def follow(other_user)
    following << other_user unless self == other_user || following?(other_user)
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.exists?(other_user.id)
  end
end
