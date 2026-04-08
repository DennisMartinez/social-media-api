# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user

  has_many :likes, as: :likeable, dependent: :destroy
  # has_many :liked_by_users, through: :likes, source: :user

  validates :content, presence: true, length: { maximum: 500 }

  def can_destroy?(current_user)
    user_id == current_user.id
  end
end
