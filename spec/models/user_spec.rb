require 'rails_helper'

###Commented out activity must have categories validation to be able to create activities/categories.###

RSpec.describe User, type: :model do

  let(:user) {User.create(id: 1, email: "fake@fake.com", image_url: "www.fake.com")}

  let(:event1) {Event.create(id: 75, name: "event1", description: "event-like", creator_id: 2, date:Time.now.localtime + 2, address: "123 N Fake St.", activity_id: 50, max_participants: 10, longitude: "20", latitude: "10")}
    sleep(3) #this puts event1 in the past while passing the validation that a new event must have a start date in the future
  let(:event2) {Event.create(id: 76, name: "event2", description: "event-like", creator_id: 2, date:Time.now.localtime + 604000, address: "123 N Fake St.", activity_id: 51, max_participants: 10, longitude: "20", latitude: "10")}
  let(:event3) {Event.create(id: 77, name: "event3", description: "event-tastic", creator_id: 1, date: Time.now.localtime + 500000, address: "541 N Fake St.", activity_id: 51, max_participants: 5, longitude: "10", latitude: "50")}
  let(:event4) {Event.create(id: 78, name: "event4", description: "event-tastical", creator_id: 1, date: Time.now.localtime + 400000, address: "888 N Fake St.", activity_id: 51, max_participants: 1, longitude: "100", latitude: "150")}
  let(:event5) {Event.create(id: 79, name: "event5", description: "event-tastical-o", creator_id: 1, date: Time.now.localtime + 2, address: "999 N Fake St.", activity_id: 51, max_participants: 3, longitude: "120", latitude: "100")}

  let(:sports) {Category.create(id: 99, name: "sports")}
  let(:golf) {Activity.create(id: 50, name: "golf")}
  let(:baseball) {Activity.create(id: 51, name: "baseball")}


  describe 'past_events' do
    it 'returns events user has attended with start dates before RIGHT NOW' do
      user.joined_events << event1
      user.joined_events << event2
      expect(user.past_events.length).to eq(1)
    end
  end

  describe 'upcoming_events' do
    it 'returns events user has joined with start dates after RIGHT NOW' do
      user.joined_events << event1
      user.joined_events << event2
      expect(user.past_events.length).to eq(1)
    end
  end

  describe 'appealing_activities' do
    it 'returns liked activities of the user' do
      sports.associated_activities << golf
      sports.associated_activities << baseball
      user.liked_categories << sports
      user.disliked_activities << golf
      expect(user.appealing_activities.length).to eq(1)
    end
  end

  #need a work around for distance to user

  # describe 'appealing_events' do
  #   it 'returns future events that match the liked activities of the user' do
  #     golf.events << event1
  #     baseball.events << event2
  #     # event1.distance_to_user = 1
  #     # event2.distance_to_user = 1
  #     sports.associated_activities << golf
  #     sports.associated_activities << baseball
  #     user.liked_categories << sports
  #     user.disliked_activities << golf
  #     expect(user.appealing_events.length).to eq(1)
  #   end
  # end

  describe 'created_events_by_date' do
    it 'returns events created by user sorted by start date' do
      event1.creator_id
      event2.creator_id
      event3.creator_id
      event4.creator_id
      event5.creator_id
      expect(user.created_events_by_date.first.name).to eq("event5")
      expect(user.created_events_by_date.length).to eq(3)
    end
  end

    describe 'created_events_by_date_future' do
    it 'returns events created by user sorted by start date' do
      event1.creator_id
      event2.creator_id
      event3.creator_id
      event4.creator_id
      event5.creator_id
      expect(user.created_events_by_date_future.first.name).to eq("event4")
      expect(user.created_events_by_date_future.length).to eq(2)
    end
  end

    describe 'created_events_by_date_past' do
    it 'returns events created by user sorted by start date' do
      event1.creator_id
      event2.creator_id
      event3.creator_id
      event4.creator_id
      event5.creator_id
      expect(user.created_events_by_date_past.first.name).to eq("event5")
      expect(user.created_events_by_date_past.length).to eq(1)
    end
  end
end
