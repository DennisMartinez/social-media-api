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
FactoryBot.define do
  factory :user do
    name { 'Test User' }
    email { 'user@example.com' }
    password { 'password' }
  end
end
