require 'rails_helper'

describe Event do

  let(:category1) { Category.create(name: "Entertainment & Music") }
  let(:activity1) { Activity.create(name: "Watch TV") }
  let(:cat_act_relationship) { ActivityCategory.create!(activity: activity1, category: category1) }

  let(:user1) { User.create(email: "lydia@lydia.com",
              bio: "Once a girl, now a crab traveling through space and time",
              image_url: "http://www.devoncrab.com/files/4213/0028/9117/610-465_Crab.whole_crab.jpg",
              facebook_id: "100000000000000",
              points: 0,
              name: "Lydia Nash",
              latitude: 41.885311,
              longitude: -87.6285002,
              mile_preference: 10,
              show_future_events: true,
              show_past_events: true) }

  let(:user2) { User.create(email: "sarah@sarah.com",
              bio: "Also a crab - also traveling through time",
              image_url: "http://www.devoncrab.com/files/4213/0028/9117/610-465_Crab.whole_crab.jpg",
              facebook_id: "100000000000000",
              points: 0,
              name: "Sarah Finken-Hernandez",
              latitude: 41.885311,
              longitude: -87.6285002,
              mile_preference: 20,
              show_future_events: true,
              show_past_events: true) }

  let(:user3) { User.create(email: "mirror@maru.com",
              bio: "Not a crab, a cat",
              image_url: "http://www.devoncrab.com/files/4213/0028/9117/610-465_Crab.whole_crab.jpg",
              facebook_id: "100000000000000",
              points: 0,
              name: "Mirror Maru",
              latitude: 41.885311,
              longitude: -87.6285002,
              mile_preference: 30,
              show_future_events: true,
              show_past_events: true) }

  let(:got)   { Event.create(name: "GoT Watch Party",
              description: "Let's watch the new episde of Game of Thrones",
              creator: user2,
              date: Time.now + (60*60*24*7),
              location_name: nil,
              address: "351 W Hubbard St, Chicago, IL, United States",
              activity: activity1,
              max_participants: 2) }

  describe '#open_spots' do
    it 'returns the number of open spots an event has' do
      got.users_events.create(user: user1)
      expect(got.open_spots).to eq(1)
    end
  end

  describe '#open?' do
    it 'returns true if there are open spots in an event' do
      got.users_events.create(user: user1)
      expect(got.open?).to eq(true)
    end

    it 'returns false if there no open spots in an event' do
      got.users_events.create(user: user1)
      got.users_events.create(user: user3)
      expect(got.open?).to eq(false)
    end
  end

  describe '#distance_to_user' do
    it 'returns the distance in miles between an event and the current user' do
      expect(got.distance_to_user([user2.latitude,user2.longitude])).to eq(0.5526471643612861)
    end
  end

  describe 'validations' do
    it 'requires an event to be in the future' do
      pre_num_of_events = Event.count

      Event.create(name: "GoT Watch Party II",
                  description: "Another GoT party",
                  creator: user2,
                  date: Time.now - 60,
                  location_name: nil,
                  address: "351 W Hubbard St, Chicago, IL, United States",
                  activity: activity1,
                  max_participants: 2)

      post_num_of_events = Event.count
      expect(pre_num_of_events).to eq(post_num_of_events)
    end

    it 'requires an event to be within 7 days' do
      pre_num_of_events = Event.count

      Event.create(name: "GoT Watch Party II",
                  description: "Another GoT party",
                  creator: user2,
                  date: Time.now + (60*60*24*7) + 10,
                  location_name: nil,
                  address: "351 W Hubbard St, Chicago, IL, United States",
                  activity: activity1,
                  max_participants: 2)

      post_num_of_events = Event.count
      expect(pre_num_of_events).to eq(post_num_of_events)
    end
  end
end
