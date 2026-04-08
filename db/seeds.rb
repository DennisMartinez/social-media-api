# frozen_string_literal: true

return if Rails.env.production?

User.create(name: 'Admin User', email: 'admin@example.com', password: 'admin')

User.create(name: 'Jason Voorhees', email: 'jason.voorhees@example.com', password: 'password')
User.create(name: 'Freddy Krueger', email: 'freddy.krueger@example.com', password: 'password')
User.create(name: 'Michael Myers', email: 'michael.myers@example.com', password: 'password')
User.create(name: 'Charles Lee Ray', email: 'charles.lee.ray@example.com', password: 'password')
User.create(name: 'Leatherface Slaughter', email: 'leatherface.slaughter@example.com', password: 'password')
