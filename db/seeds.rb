# frozen_string_literal: true

return if Rails.env.production?

User.create(name: 'Admin User', email: 'admin@example.com', password: 'admin')

jason_voorhees = User.create(name: 'Jason Voorhees', email: 'jason.voorhees@example.com', password: 'password')
michael_myers = User.create(name: 'Michael Myers', email: 'michael.myers@example.com', password: 'password')
charles_lee_ray = User.create(name: 'Charles Lee Ray', email: 'charles.lee.ray@example.com', password: 'password')
leatherface_slaughter = User.create(name: 'Leatherface Slaughter', email: 'leatherface.slaughter@example.com',
                                    password: 'password')

jason_voorhees.avatar.attach(
  io: File.open(Rails.root.join('db/seeds/avatars/jason_voorhees.jpg')), filename: 'jason_voorhees.jpg'
)
michael_myers.avatar.attach(
  io: File.open(Rails.root.join('db/seeds/avatars/michael_myers.jpg')), filename: 'michael_myers.jpg'
)
charles_lee_ray.avatar.attach(
  io: File.open(Rails.root.join('db/seeds/avatars/charles_lee_ray.jpg')), filename: 'charles_lee_ray.jpg'
)
leatherface_slaughter.avatar.attach(
  io: File.open(Rails.root.join('db/seeds/avatars/leatherface_slaughter.jpg')), filename: 'leatherface_slaughter.jpg'
)

jason_voorhees.posts.create(content: 'Just got a new machete! #excited')
jason_voorhees.posts.create(content: 'Anyone want to go camping this weekend? #fun')
jason_voorhees.follow(leatherface_slaughter)

freddy_krueger = User.create(name: 'Freddy Krueger', email: 'freddy.krueger@example.com', password: 'password')
freddy_krueger.posts.create(content: 'Had a nightmare about work last night... #stress')
freddy_krueger.posts.create(content: 'Looking for some new victims to haunt...')
freddy_krueger.follow(jason_voorhees)

michael_myers.posts.create(content: 'Just moved into a new house... #excited')
michael_myers.posts.create(content: 'Anyone want to come over for a party? #fun')
michael_myers.follow(jason_voorhees)

charles_lee_ray.posts.create(content: 'Just got a new doll! #excited')
charles_lee_ray.posts.create(content: 'Anyone want to play with my doll? #fun')
charles_lee_ray.follow(jason_voorhees)
charles_lee_ray.follow(freddy_krueger)

leatherface_slaughter.posts.create(content: 'Just got a new chainsaw! #excited')
leatherface_slaughter.posts.create(content: 'Anyone want to go for a ride? #fun')
leatherface_slaughter.follow(michael_myers)
