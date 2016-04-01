# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'date'

20.times do
  User.create(email: Faker::Internet.email, bio: Faker::Lorem.paragraph(8), image_url: Faker::Avatar.image, facebook_id: "123456789", points: rand(0..90), last_location: "this is a location")
end

20.times do
  Event.create(name: Faker::Lorem.word, description: Faker::Lorem.paragraph(4), creator_id: rand(1..20), date: DateTime.now, address: Faker::Address.street_address, latitude: rand(1..100), longitude: rand(1..100), activity_id: rand(1..10))
end

10.times do
  Category.create(name: Faker::Hacker.noun)
end

40.times do
  Activity.create(name: Faker::Hipster.word)
  ActivityCategory.create(activity_id: rand(1..40), category_id: rand(1..10))
end

20.times do
  UsersEvent.create(user_id: rand(1..20), event_id: rand(1..20))
  Comment.create(user_id: rand(1..20), event_id: rand(1..20), content: Faker::Lorem.paragraph(2))
  UsersActivity.create(user_id: rand(1..20), activity_id: rand(1..40))
  UsersCategory.create(user_id: rand(1..20), category_id: rand(1..10))
end
