class Event < ActiveRecord::Base
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
    self.joined_users.to_a.length < self.max_participants ? true : false
  end


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
