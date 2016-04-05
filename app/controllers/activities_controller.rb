class ActivitiesController < ApplicationController
  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to new_event_path
    else
      # repopulate with the categories when name is empty
      render new_activity_path(@activity)
    end
  end

  private
  def activity_params
    params.require(:activity).permit(:name, :all_categories)
  end
end
