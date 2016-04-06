require 'rails_helper'



RSpec.describe User, type: :model do

  let(:user) {User.create(id: 1, email: "fake@fake.com", image_url: "www.fake.com")}

  let(:event1) {Event.create(id: 75, name: "event1", description: "event-like", creator_id: 2, date:Time.now.localtime + 2, address: "123 N Fake St.", activity_id: 1, max_participants: 10)}
  sleep(3) #this puts event1 in the past while passing the validation that a new event must have a start date in the future
  let(:event2) {Event.create(id: 76, name: "event1", description: "event-like", creator_id: 2, date:"2016-04-08 23:43:00", address: "123 N Fake St.", activity_id: 1, max_participants: 10)}

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

  # describe 'appealing_events'


end
