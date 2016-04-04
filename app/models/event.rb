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

  def self.event_locations
    all_event_location_data = []
    Event.all.each do |event|
      all_event_location_data << [event.name, event.latitude, event.longitude, event.id, event.address]
    end
    all_event_location_data
  end

  def open?
    if self.joined_users <= self.max_participants
      true
    end
  end

  def push_notification
    pusher_client = Pusher::Client.new(
      app_id: '194717',
      key: 'c7a6150d22d40eea7bca',
      secret: '76c36e83b489767cef0a',
      encrypted: true
    )

    pusher_client.trigger('test_channel', 'my_event', {
      message: 'New Event Added!'
    })

  end

  private
  def event_cannot_be_in_past
    errors.add(:date, "of event must occur in the future") if !date.blank? && date < Time.now
  end

  def event_must_be_within_seven_days
    errors.add(:date, "of event must occur within 7 days") if !date.blank? && date > Time.now + ((60*60*24*7) + 1)
  end

end
