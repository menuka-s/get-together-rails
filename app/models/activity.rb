class Activity < ActiveRecord::Base

  has_many :activity_categories
  has_many :associated_categories, through: :activity_categories, source: :category
  has_many :users_activities
  has_many :unattached_users, through: :users_activities, source: :user
  has_many :events

end
