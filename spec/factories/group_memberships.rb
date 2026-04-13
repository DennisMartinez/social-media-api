# == Schema Information
#
# Table name: group_memberships
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_group_memberships_on_group_id              (group_id)
#  index_group_memberships_on_user_id               (user_id)
#  index_group_memberships_on_user_id_and_group_id  (user_id,group_id) UNIQUE
#
# Foreign Keys
#
#  group_id  (group_id => groups.id)
#  user_id   (user_id => users.id)
#
FactoryBot.define do
  factory :group_membership do
    user { nil }
    group { nil }
  end
end
