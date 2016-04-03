class User < ActiveRecord::Base
  require 'date'

  has_many :users_events
  has_many :joined_events, through: :users_events, source: :event
  has_many :comments
  has_many :commented_events, through: :comments, source: :event
  has_many :created_events, class_name: "Event", foreign_key: :creator_id
  has_many :users_activities
  has_many :disliked_activities, through: :users_activities, source: :activity
  has_many :users_categories
  has_many :liked_categories, through: :users_categories, source: :category

  def past_events
    @past_events = self.joined_events.where("date < ?", Time.now)
  end

  def upcoming_events
    @user_events = self.joined_events.where("date > ?", Time.now)
  end

  # So, we should probably test all this stuff, but it seems to be working

  def appealing_events
    activities = self.appealing_activities
    all_event_data = []

    activities.each do |activity|
      activity.events.each do |event|
        if event.date > Time.now
          all_event_data << [event.name, event.latitude, event.longitude, event.id, event.address, event.date]
        end
      end
    end

    all_event_data
  end

  # private
  def appealing_activities
    events = []
    self.liked_categories.each do |category|
      category.associated_activities.each do |activity|
        events << activity
      end
    end
    events.uniq - self.disliked_activities.to_a
  end

end
