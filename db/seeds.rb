# frozen_string_literal: true

return if Rails.env.production?

if User.find_by(email: 'admin@example.com').blank?
  User.create!(name: 'Admin User', email: 'admin@example.com', password: 'admin')
end
