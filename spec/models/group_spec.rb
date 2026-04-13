# frozen_string_literal: true

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
require 'rails_helper'

RSpec.describe Group do
  pending "add some examples to (or delete) #{__FILE__}"
end
