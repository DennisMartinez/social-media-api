# frozen_string_literal: true

require 'open-uri'

class GenerateFakeDataJob < ApplicationJob
  queue_as :default

  DEFAULT_USER_COUNT = 100
  DEFAULT_GROUP_COUNT = 20

  def perform(user_limit = DEFAULT_USER_COUNT, group_limit = DEFAULT_GROUP_COUNT)
    reset_data
    truncate_all

    admin_users = create_admin_users
    non_admin_users = create_users(user_limit)
    users = admin_users + non_admin_users

    posts = create_posts(users)

    create_groups(non_admin_users, group_limit)
    create_comments(users, posts)
    create_likes(users, posts)
    create_follows(users)
  end

  private

  def reset_data
    User.destroy_all
  end

  def truncate_all
    connection = ActiveRecord::Base.connection

    tables = connection.tables - %w[schema_migrations ar_internal_metadata]

    tables.each do |table|
      connection.execute("DELETE FROM #{connection.quote_table_name(table)}")
    end

    # Reset SQLite auto-increment counters
    return unless connection.adapter_name == 'SQLite'

    tables.each do |table|
      connection.execute("DELETE FROM sqlite_sequence WHERE name='#{table}'")
    end
  end

  def create_admin_users
    admin = User.create(name: 'Admin User', email: 'admin@example.com', password: 'admin',
                        bio: 'Hi! I am the admin user. I can do anything!')
    admin.avatar.attach(
      io: URI("https://i.pravatar.cc/150?u=#{admin.email}").open,
      filename: "#{admin.id}_avatar.jpg"
    )

    [admin]
  end

  def create_users(limit)
    Array.new(limit) do
      user = User.create!(
        name: Faker::Name.name,
        email: Faker::Internet.unique.email,
        password: 'password',
        bio: Faker::Lorem.sentence(word_count: rand(10..30))
      )

      user.avatar.attach(
        io: URI("https://i.pravatar.cc/150?u=#{user.email}").open,
        filename: "#{user.id}_avatar.jpg",
        content_type: 'image/jpeg'
      )

      user
    end
  end

  def create_posts(users)
    users.flat_map do |user|
      Array.new(rand(1..5)) do
        user.posts.create!(
          content: Faker::Lorem.sentence(word_count: 10)
        )
      end
    end
  end

  def create_comments(users, posts)
    posts.each do |post|
      rand(0..10).times do
        post.comments.create!(
          user: users.sample,
          content: Faker::Lorem.sentence(word_count: 5)
        )
      end
    end
  end

  def create_likes(users, posts)
    posts.each do |post|
      users.sample(rand(0..20)).each do |user|
        post.likes.create!(user: user)
      end
    end
  end

  def create_follows(users)
    users.each do |user|
      users.sample(rand(0..50)).each do |other|
        next if other == user

        user.following << other unless user.following.exists?(other.id)
      end
    end
  end

  def create_groups(users, limit)
    Array.new(limit) do
      group = Group.create!(
        name: Faker::Lorem.sentence(word_count: rand(2..10)).titleize,
        bio: Faker::Lorem.sentence(word_count: rand(10..30)),
        owner: users.sample
      )

      image_url = Faker::LoremFlickr.image(size: '150x150', search_terms: ['group'])
      group.avatar.attach(
        io: URI(image_url).open,
        filename: "#{group.id}_avatar.jpg",
        content_type: 'image/jpeg'
      )

      group.members << users.sample(rand(5..20))
      group
    end
  end
end
