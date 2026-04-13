# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  bio        :text(1000)
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_groups_on_name  (name) UNIQUE
#
class Group < ApplicationRecord
  has_one_attached :avatar

  has_many :group_memberships, dependent: :destroy
  has_many :members, through: :group_memberships, source: :user
  has_many :posts, dependent: :nullify

  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :bio, length: { maximum: 1000 }, allow_nil: true
end
