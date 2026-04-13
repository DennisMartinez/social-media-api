# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :text(500)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer
#  user_id    :integer          not null
#
# Indexes
#
#  index_posts_on_group_id  (group_id)
#  index_posts_on_user_id   (user_id)
#
# Foreign Keys
#
#  group_id  (group_id => groups.id)
#  user_id   (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :content, presence: true, length: { maximum: 500 }
  validate :group_membership

  def likes_count
    likes.size
  end

  def comments_count
    comments.size
  end

  private

  def group_membership
    return if group.nil? || group.group_memberships.exists?(user_id: user.id)

    errors.add(:group, 'must be a group you are a member of')
  end
end
