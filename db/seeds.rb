# frozen_string_literal: true

return if Rails.env.production?

User.create(name: 'Admin User', email: 'admin@example.com', password: 'admin')
