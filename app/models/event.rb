class Event < ActiveRecord::Base
  require 'date'

  has_many :users_events
  has_many :joined_users, through: :users_events, source: :user
  belongs_to :creator, class_name: "User"
  has_many :comments
  has_many :commenting_users, through: :comments, source: :user
  belongs_to :activity

  #/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/
  #comment this back in after seed, for user functionality
  geocoded_by :address
  after_validation :geocode
  #/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/

  #/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/* UNCOMMENT address TOO
  validates_presence_of :name, :description, :date, :activity_id, :address
  validate :event_cannot_be_in_past

  private
  def event_cannot_be_in_past
    errors.add(:date, "of event must occur in the future") if
      !date.blank? && date < Time.now
  end

end
