class User < ActiveRecord::Base
  include UsersHelper
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

  after_initialize :init

  def init
    self.mile_preference ||= 20
  end

  def past_events
    @past_events = self.joined_events.where("date < ?", Time.now + 18000) + self.created_events.where("date < ?", Time.now + 18000)
    return @past_events.sort{|eventa, eventb| eventa.date <=> eventb.date}
  end

  def upcoming_events
    @user_events = self.joined_events.where("date > ?", Time.now + 18000) + self.created_events.where("date > ?", Time.now + 18000)
    return @user_events.sort{|eventa, eventb| eventa.date <=> eventb.date}
  end

  # So, we should probably test all this stuff, but it seems to be working

  def appealing_events
    activities = self.appealing_activities
    @all_event_data = []

    activities.each do |activity|
      activity.events.each do |event|
         if !event.longitude.nil?
           if event.date > Time.now && event.distance_to_user([self.latitude, self.longitude]) <= self.mile_preference.to_f
             @all_event_data << event
           end
        end
      end
    end

    @all_event_data
  end

  def appealing_events_by_groups
    groups = []
    small_events = []
    small_group = []
    @all_event_data = self.appealing_events if @all_event_data.nil?
    @all_event_data.each do |event|
      if event.max_participants > 19
        groups << [ event ]
      else
        small_events << event if event
      end
    end

    small_events.each do |event|
      if small_group.count > 3
        groups << small_group[0..3]
        small_group = []
      end
      small_group << event
    end
    groups
  end

  def created_events_by_date
    self.created_events.sort_by { |event| event.date }
  end

  def created_events_by_date_future
    self.created_events.where("date > ?", (Time.now + 18000)).sort_by { |event| event.date }
  end

  def created_events_by_date_past
    self.created_events.where("date < ?", (Time.now + 18000)).sort_by { |event| event.date }
  end

  def appealing_events_by_date
    @all_event_data = self.appealing_events if @all_event_data.nil?
    @all_event_data.sort_by { |event| event.date }
  end

  def appealing_events_by_proximity
    @all_event_data = self.appealing_events if @all_event_data.nil?

    # if events have a longitude, sort normally; otherwise, move to end
    @all_event_data.sort { |a,b| a.longitude && b.longitude ? a.distance_to_user([self.latitude, self.longitude]) <=> b.distance_to_user([self.latitude, self.longitude]) : a.longitude ? -1 : 1 }
  end

  # def appealing_events_by_recommended
  #   @all_event_data = self.appealing_events if @all_event_data.nil?

  #   # if events have a longitude, sort normally; otherwise, move to end
  #   @all_event_data.sort { |a,b| a.recommendations && b.recommendations }
  # end

  def appealing_activities
    activities = []
    self.liked_categories.each do |category|
      category.associated_activities.each do |activity|
        activities << activity
      end
    end
    activities.uniq - self.disliked_activities.to_a
  end


  # def interests_in_common
  #   my_interests = Activity.all - self.disliked_activities
  #   shared_interests = my_interests & current_user_activities
  # end
end


