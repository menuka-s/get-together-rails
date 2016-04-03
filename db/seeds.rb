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
  Event.create(name: Faker::Lorem.word, description: Faker::Lorem.paragraph(4), creator_id: rand(1..20), date: Time.now + (60*60*24*7), address: "", latitude: lat_rand.rand(41.835567..41.903828), longitude: long_rand.rand(-87.686386..-87.617266), activity_id: rand(1..12))
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
Activity.create(name: "Play Board Games")
ActivityCategory.create(activity_id: 2, category_id: 1)
ActivityCategory.create(activity_id: 2, category_id: 8)
Activity.create(name: "Live Action Role Play")
ActivityCategory.create(activity_id: 3, category_id: 1)


Activity.create(name: "Play Soccer")
ActivityCategory.create(activity_id: 4, category_id: 2)
ActivityCategory.create(activity_id: 4, category_id: 1)
ActivityCategory.create(activity_id: 4, category_id: 7)
Activity.create(name: "Play Basketball")
ActivityCategory.create(activity_id: 5, category_id: 2)
ActivityCategory.create(activity_id: 5, category_id: 1)
Activity.create(name: "Play Baseball")
ActivityCategory.create(activity_id: 6, category_id: 2)
ActivityCategory.create(activity_id: 6, category_id: 1)
ActivityCategory.create(activity_id: 6, category_id: 7)
Activity.create(name: "Play Frisbee")
ActivityCategory.create(activity_id: 7, category_id: 2)
ActivityCategory.create(activity_id: 7, category_id: 1)
ActivityCategory.create(activity_id: 7, category_id: 7)
Activity.create(name: "Play Tennis")
ActivityCategory.create(activity_id: 8, category_id: 2)
ActivityCategory.create(activity_id: 8, category_id: 1)
Activity.create(name: "Rock-Climbing")
ActivityCategory.create(activity_id: 9, category_id: 2)
ActivityCategory.create(activity_id: 9, category_id: 7)
Activity.create(name: "Watch Sports on TV")
ActivityCategory.create(activity_id: 10, category_id: 2)


Activity.create(name: "Yoga")
ActivityCategory.create(activity_id: 11, category_id: 3)
Activity.create(name: "Spa")
ActivityCategory.create(activity_id: 12, category_id: 3)
Activity.create(name: "Make Smoothies")
ActivityCategory.create(activity_id: 13, category_id: 3)


Activity.create(name: "Happy Hour")
ActivityCategory.create(activity_id: 14, category_id: 4)
Activity.create(name: "BBQ")
ActivityCategory.create(activity_id: 15, category_id: 4)
ActivityCategory.create(activity_id: 15, category_id: 7)
Activity.create(name: "Thai food")
ActivityCategory.create(activity_id: 16, category_id: 4)
Activity.create(name: "Chinese food")
ActivityCategory.create(activity_id: 17, category_id: 4)
Activity.create(name: "American food")
ActivityCategory.create(activity_id: 18, category_id: 4)


Activity.create(name: "Museum")
ActivityCategory.create(activity_id: 19, category_id: 5)
ActivityCategory.create(activity_id: 19, category_id: 8)
Activity.create(name: "Go to a Lecture")
ActivityCategory.create(activity_id: 20, category_id: 5)
Activity.create(name: "Take a Class")
ActivityCategory.create(activity_id: 21, category_id: 5)


Activity.create(name: "Rally")
ActivityCategory.create(activity_id: 22, category_id: 6)
Activity.create(name: "Discussion")
ActivityCategory.create(activity_id: 23, category_id: 6)
Activity.create(name: "Watch a Political Movie")
ActivityCategory.create(activity_id: 24, category_id: 6)


Activity.create(name: "Hiking")
ActivityCategory.create(activity_id: 25, category_id: 7)
Activity.create(name: "Camping")
ActivityCategory.create(activity_id: 26, category_id: 7)
Activity.create(name: "Spelunking")
ActivityCategory.create(activity_id: 27, category_id: 7)
Activity.create(name: "Picnic")
ActivityCategory.create(activity_id: 28, category_id: 7)
ActivityCategory.create(activity_id: 28, category_id: 8)

Activity.create(name: "Go to the Zoo")
ActivityCategory.create(activity_id: 29, category_id: 8)
ActivityCategory.create(activity_id: 29, category_id: 7)
Activity.create(name: "Go to a Playground")
ActivityCategory.create(activity_id: 30, category_id: 8)
ActivityCategory.create(activity_id: 30, category_id: 7)
Activity.create(name: "Go to a Kid Moie")
ActivityCategory.create(activity_id: 31, category_id: 8)


Activity.create(name: "Concert")
ActivityCategory.create(activity_id: 32, category_id: 9)
Activity.create(name: "Opera")
ActivityCategory.create(activity_id: 33, category_id: 9)
Activity.create(name: "See a Movie")
ActivityCategory.create(activity_id: 34, category_id: 9)
Activity.create(name: "See a Play")
ActivityCategory.create(activity_id: 35, category_id: 9)


Activity.create(name: "Hackathon")
ActivityCategory.create(activity_id: 36, category_id: 10)
Activity.create(name: "Tour DBC")
ActivityCategory.create(activity_id: 37, category_id: 10)
Activity.create(name: "Coder Meetup")
ActivityCategory.create(activity_id: 38, category_id: 10)


Activity.create(name: "Dog Park Meetup")
ActivityCategory.create(activity_id: 39, category_id: 11)
ActivityCategory.create(activity_id: 39, category_id: 7)
Activity.create(name: "Kittens!")
ActivityCategory.create(activity_id: 40, category_id: 11)
Activity.create(name: "Bird-watching")
ActivityCategory.create(activity_id: 41, category_id: 11)
ActivityCategory.create(activity_id: 41, category_id: 7)




20.times do
  UsersEvent.create(user_id: rand(1..20), event_id: rand(1..20))
  Comment.create(user_id: rand(1..20), event_id: rand(1..20), content: Faker::Lorem.paragraph(2))
  UsersActivity.create(user_id: rand(1..20), activity_id: rand(1..40))
  UsersCategory.create(user_id: rand(1..20), category_id: rand(1..10))
end
