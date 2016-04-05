class Activity < ActiveRecord::Base

  has_many :activity_categories
  has_many :associated_categories, through: :activity_categories, source: :category
  has_many :users_activities
  has_many :unattached_users, through: :users_activities, source: :user
  has_many :events

  validates_presence_of :name
  validate :activity_must_have_categories

  def all_categories=(new_categories)
    @new_categories = new_categories
    @new_categories.split(' ').each do |category|
      assigned_cat = Category.find_by(name: category)
      self.activity_categories.new(activity_id: self.id, category_id: assigned_cat.id)
    end
  end

  # Note: the form gets mad if this method isn't here - don't know why? (LN)
  def all_categories
  end

  private
  def activity_must_have_categories
    errors.add("Activity", " must have categories") if @new_categories.length == 0
  end

end
