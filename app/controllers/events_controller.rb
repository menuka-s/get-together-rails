class EventsController < ApplicationController
  include UsersHelper
  include EventsHelper


  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    @activities = Activity.all
  end

  def create
    @event = Event.new(event_params)
    # @event.creator_id = current_user.id
    @event.creator_id = 1
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
