class Category < ActiveRecord::Base

  has_many :activity_categories
  has_many :associated_activities, through: :activity_categories, source: :activity
  has_many :user_categories
  has_many :attached_users, through: :user_categories, source: :user

end
