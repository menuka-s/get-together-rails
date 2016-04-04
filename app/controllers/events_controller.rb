class EventsController < ApplicationController
  include UsersHelper
  include EventsHelper

  def index
    @current_location = [ current_user.latitude, current_user.longitude ]
    @user_appealing_events = current_user.appealing_events
    @user_appealing_events_by_date = current_user.appealing_events_by_date
    @user_appealing_events_by_proximity = current_user.appealing_events_by_proximity
  end

  def index_ajax
    @current_location = [ current_user.latitude, current_user.longitude ]
    @user_appealing_events = current_user.appealing_events
    @user_appealing_events_by_date = current_user.appealing_events_by_date
    @user_appealing_events_by_proximity = current_user.appealing_events_by_proximity
    render :'events/_events', :layout => false
  end

  def show
    @event = Event.find(params[:id])
    @comment = Comment.new
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
      @event.push_notification
      flash[:notice] = "Your event was successfully created"
      redirect_to @event
    else
      @activities = Activity.all
      render new_event_path(@event)
    end
  end

  private
  def event_params
    params.require(:event).permit(:name, :description, :date, :location_name, :address, :activity_id, :max_participants)
  end

end
