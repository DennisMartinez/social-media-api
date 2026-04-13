# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  bio        :text(1000)
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :integer          not null
#
# Indexes
#
#  index_groups_on_name      (name) UNIQUE
#  index_groups_on_owner_id  (owner_id)
#
# Foreign Keys
#
#  owner_id  (owner_id => users.id)
#
FactoryBot.define do
  factory :group do
    name { 'MyString' }
    bio { 'MyText' }
  end
end
