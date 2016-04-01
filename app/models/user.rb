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
    @past_events = self.joined_events.where("date < ?", DateTime.now)
  end

  def upcoming_events
    @user_events = self.joined_events.where("date > ?", DateTime.now)
  end


end
