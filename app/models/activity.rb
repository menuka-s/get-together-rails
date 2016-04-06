class Activity < ActiveRecord::Base

  has_many :activity_categories
  has_many :associated_categories, through: :activity_categories, source: :category
  has_many :users_activities
  has_many :unattached_users, through: :users_activities, source: :user
  has_many :events

  validates_presence_of :name
  validate :activity_must_have_categories

  def all_categories=(all_category_ids)
    # For some reason the array comes in with an empty string as the last index, which is why I pop it off
    all_category_ids.pop
    @all_category_ids = all_category_ids
    @all_category_ids.each do |category_id|
      self.activity_categories.new(activity_id: self.id, category_id: category_id.to_i)
    end
  end

  # Note: the form gets mad if this method isn't here - don't know why? (LN)
  def all_categories
  end

  private
  def activity_must_have_categories
    if @all_category_ids
      errors.add("Activity", " must have categories") if @all_category_ids.length == 0
    end
  end

end
