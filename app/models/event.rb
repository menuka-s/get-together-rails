class Event < ActiveRecord::Base

  has_many :users_events
  has_many :joined_users, through: :users_events, source: :user
  belongs_to :creator, class_name: "User"
  has_many :comments
  has_many :commenting_users, through: :comments, source: :user

# Add validation that requires event date must be in the future?


end
