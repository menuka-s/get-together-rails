class EventsController < ApplicationController
  include UsersHelper
  include EventsHelper

  def index
    @current_location = [ current_user.latitude, current_user.longitude ]
    @user_appealing_events = current_user.appealing_events
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    @activities = Activity.all
  end

  def create
    @event = Event.new(event_params)
    @event.creator_id = current_user.id
    @event.activity_id = Activity.find_by(name: params[:activity_name]).id
    if @event.save
      flash[:notice] = "Your event was successfully created"
      redirect_to @event
    else
      @activities = Activity.all
      render new_event_path(@event)
    end
  end

  private
  def event_params
    params.require(:event).permit(:name, :description, :date, :location_name, :address, :activity_id)
  end

end
