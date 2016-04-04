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
    @all_event_data = []

    activities.each do |activity|
      activity.events.each do |event|
        if event.date > Time.now
          @all_event_data << event
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


    # small_events.each do |activity,events|
    #   small_group = []
    #   events.each do |event|
    #     if small_group.count > 3 
    #       groups << small_group[0..3]
    #       small_group = [] 
    #     end 
    #     small_group << event
    #   end
    #   groups << small_group if small_group.count > 0
    #   small_group = []
    # end
    # groups
  end

  def appealing_events_by_date
    if @all_event_data.nil?
      self.appealing_events.sort_by { |event| event[5] }
    else
      @all_event_data.sort_by { |event| event[5] }
    end
  end

  def appealing_events_by_proximity
    if @all_event_data.nil?
      self.appealing_events.sort_by { |event| event[6] }
    else
      @all_event_data.sort_by { |event| event[6] }
    end
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
