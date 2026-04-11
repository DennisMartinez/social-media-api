# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_type :string           not null
#  content          :text(500)        not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  commentable_id   :integer          not null
#  user_id          :integer          not null
#
# Indexes
#
#  index_comments_on_commentable  (commentable_type,commentable_id)
#  index_comments_on_user_id      (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :likes, as: :likeable, dependent: :destroy

  validates :content, presence: true, length: { maximum: 500 }
end
