class EventsController < ApplicationController
  include UsersHelper
  include EventsHelper

  def new
    @event = Event.new
    @activities = Activity.all
  end

  def create
    @event = Event.new(event_parms)
    # @event.creator_id = current_user.id
    @event.creator_id = 1
    @event.save
    flash[:notice] = "Your event was successfully created"
    redirect_to @event
  end

  def show
    @event = Event.find(params[:id])
  end

  private
  def event_parms
    params.require(:event).permit(:name, :description, :date, :location_name, :address, :activity_id)
  end



end
