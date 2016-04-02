# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

long_rand = Random.new(1234)
lat_rand = Random.new(5678)
require 'date'

20.times do
  User.create(email: Faker::Internet.email, bio: Faker::Lorem.paragraph(8), image_url: Faker::Avatar.image, facebook_id: "123456789", points: rand(0..90), last_location: "this is a location")
end

20.times do
  Event.create(name: Faker::Lorem.word, description: Faker::Lorem.paragraph(4), creator_id: rand(1..20), date: DateTime.now, address: Faker::Address.street_address, latitude: lat_rand.rand(41.835567..41.903828), longitude: long_rand.rand(-87.686386..-87.617266), activity_id: rand(1..12))
end

Category.create(name: "Games")
Category.create(name: "Sports")
Category.create(name: "Health & Fitness")
Category.create(name: "Food & Drink")
Category.create(name: "Educational")
Category.create(name: "Politics")
Category.create(name: "Outdoors")
Category.create(name: "Family")
Category.create(name: "Entertainment & Music")
Category.create(name: "Technology")
Category.create(name: "Pets & Animals")


Activity.create(name: "Go Bowling")
ActivityCategory.create(activity_id: 1, category_id: 1)
ActivityCategory.create(activity_id: 1, category_id: 2)
Activity.create(name: "Play Soccer")
ActivityCategory.create(activity_id: 2, category_id: 2)
ActivityCategory.create(activity_id: 2, category_id: 1)
ActivityCategory.create(activity_id: 2, category_id: 7)
Activity.create(name: "Yoga")
ActivityCategory.create(activity_id: 3, category_id: 3)
Activity.create(name: "Happy Hour")
ActivityCategory.create(activity_id: 4, category_id: 4)
Activity.create(name: "Museum")
ActivityCategory.create(activity_id: 5, category_id: 5)
Activity.create(name: "Anti-Trump Rally")
ActivityCategory.create(activity_id: 6, category_id: 6)
Activity.create(name: "Hiking")
ActivityCategory.create(activity_id: 7, category_id: 7)
Activity.create(name: "Picnic")
ActivityCategory.create(activity_id: 8, category_id: 8)
Activity.create(name: "Concert")
ActivityCategory.create(activity_id: 9, category_id: 9)
Activity.create(name: "Hackathon")
ActivityCategory.create(activity_id: 10, category_id: 10)
Activity.create(name: "Dog Park Meetup")
ActivityCategory.create(activity_id: 11, category_id: 11)
Activity.create(name: "Brunch")
ActivityCategory.create(activity_id: 12, category_id: 4)


20.times do
  UsersEvent.create(user_id: rand(1..20), event_id: rand(1..20))
  Comment.create(user_id: rand(1..20), event_id: rand(1..20), content: Faker::Lorem.paragraph(2))
  UsersActivity.create(user_id: rand(1..20), activity_id: rand(1..40))
  UsersCategory.create(user_id: rand(1..20), category_id: rand(1..10))
end
