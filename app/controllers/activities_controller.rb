class ActivitiesController < ApplicationController
  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to new_event_path
    else
      render new_activity_path(@activity)
    end
  end

  private
  def activity_params
    params.require(:activity).permit(:name)
  end
end
