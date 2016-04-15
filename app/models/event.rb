class Event < ActiveRecord::Base
  include UsersHelper
  require 'date'
  require 'pusher'

  has_many :users_events
  has_many :joined_users, through: :users_events, source: :user
  belongs_to :creator, class_name: "User"
  has_many :comments
  has_many :commenting_users, through: :comments, source: :user
  belongs_to :activity

  geocoded_by :address
  after_validation :geocode

  validates_presence_of :name, :description, :date, :activity_id, :address
  validate :event_cannot_be_in_past
  validate :event_must_be_within_seven_days
  validate :activity_exists

  def event_date
    self.date.strftime("%m/%d/%Y") if !self.date.nil?
  end

  def event_date=(event_date)
    split_date = event_date.split('/')
    @d = Date.new(split_date[2].to_i, split_date[0].to_i, split_date[1].to_i)
  end

  def event_time
    self.date if !self.date.nil?
  end

  def event_time=(event_time)
    self.date = Time.new(@d.year, @d.month, @d.day, event_time[4], event_time[5], 00 )
  end

  # New event form requires this method to assign
  def all_category_ids
  end

  def self.event_locations
    all_event_location_data = []
    Event.all.each do |event|
      all_event_location_data << [event.name, event.latitude, event.longitude, event.id, event.address]
    end
    all_event_location_data
  end

  def activity_name=(new_activity)
    self.activity = Activity.find_by(name: new_activity)
    self.activity_name
  end

  def activity_name
    self.activity ? self.activity.name : nil
  end

  def open?
    if self.max_participants == 0
      self.max_participants = 9999999999
    end
    self.joined_users.length < self.max_participants ? true : false
  end

  def open_spots
    open = max_participants - ( joined_users.count || 0 )
    open = 0 if open < 0
    return open
  end

  # def recommendations
  #   amount_in_common = 0
  #   current_user_interests = Activity.all - user.disliked_activities
  #   creator_interests = Activity.all - self.creator.disliked_activities
  #   self.joined_users.each do |event_participant|
  #     event_participant_interests = Activity.all - event_participant.disliked_activities
  #     amount_in_common += (current_user_interests & event_participant_interests).length
  #   end
  #   amount_in_common += (current_user_interests & creator_interests).length*1.3
  #   amount_in_common / (self.joined_users.count + 1)
  # end

  def push_notification
    pusher_client = Pusher::Client.new(
      app_id: '194717',
      key: 'c7a6150d22d40eea7bca',
      secret: '76c36e83b489767cef0a',
      encrypted: true
    )

    pusher_client.trigger('test_channel', 'my_event', {
      message: 'Event'
    })

  end

  def distance_to_user(loc1)
    loc2 = [self.latitude, self.longitude] # Event location

    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c * 0.000621371 # Delta in meters converted to miles
  end

  private
  def event_cannot_be_in_past
    errors.add(:date, "of event must occur in the future") if !date.blank? && date < Time.now
  end

  def event_must_be_within_seven_days
    errors.add(:date, "of event must occur within 7 days") if !date.blank? && date > Time.now + ((60*60*24*7) + 1)
  end

  def activity_exists
    errors.add(:activity, "must exist") if self.activity_name == ""
  end

end
