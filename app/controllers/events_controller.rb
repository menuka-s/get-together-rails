class EventsController < ApplicationController
  include UsersHelper
  include EventsHelper

  def index
    @current_location,@user_appealing_events,@user_appealing_events_by_date,@user_appealing_events_by_proximity = index_locals
  end

  def index_ajax
    @current_location,@user_appealing_events,@user_appealing_events_by_date,@user_appealing_events_by_proximity = index_locals
    render :'events/_events', :layout => false
  end

  def index_tiles
    @current_location,@user_appealing_events,@user_appealing_events_by_date,@user_appealing_events_by_proximity = index_locals
    @user_appealing_events_by_groups = current_user.appealing_events_by_groups
    render :'events/tiles'
  end

  def newest_event
    ajax_return = {}
    ajax_return["status"] = 0
    newest_event = Event.last

    if current_user.appealing_events.include?(newest_event)

      ajax_return["status"] = 1
      ajax_return["event"] = newest_event
    end
    render json: ajax_return.to_json
  end

  def show
    @event = Event.find(params[:id])
    @current_location = index_locals[0]
    @comment = Comment.new
  end

  def new
    @event = Event.new
    @activity = Activity.new
    @activities = Activity.all
  end

  def create
    new_event_params = event_params
    @activity = Activity.find_by(name: new_event_params[:activity_name])

    if @activity # if the activity already exists
      new_event_params.delete("all_category_ids")
      @event = current_user.created_events.new(new_event_params)

      if @event.save
        @event.push_notification
        flash[:notice] = "Your event was successfully created"
        redirect_to @event
      else
        @activities = Activity.all
        render new_event_path(@event)
      end

    else # the activity doesn't exist
      # Create new activity and pass it the category ids
      @activity = Activity.new(name: new_event_params[:activity_name], all_categories: new_event_params[:all_category_ids])

      if @activity.save # activity passes validation
        # Create a new event with the revised event params
        new_event_params.delete("all_category_ids")
        @event = current_user.created_events.new(new_event_params)

        if @event.save # activity & event pass validation
          @event.push_notification
          flash[:notice] = "Your event was successfully created"
          redirect_to @event
        else # activity passes validation, but event does not
          @activities = Activity.all
          render new_event_path(@event)
        end

      else # the activity did not pass validation
        new_event_params.delete("all_category_ids")
        @event = current_user.created_events.new(new_event_params)

        @activity.errors.messages.each do |key,value|
          @event.errors.add(key,value.first)
        end

        @new_activity_flag = "flag" # create a flag variable to determine whether the categories checkboxes will be shown upon page load
        @activities = Activity.all
        render new_event_path(@event)
      end
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.update(event_params)
    redirect_to event_path(@event)
  end

  def destroy
    @user = current_user
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to @user
  end

  private
  def event_params
    params.require(:event).permit(:name, :description, :date, :location_name, :address, :activity_name, :max_participants, all_category_ids: [])
  end

  def index_locals
    [ [ current_user.latitude, current_user.longitude ],
        current_user.appealing_events,
        current_user.appealing_events_by_date,
        current_user.appealing_events_by_proximity
    ]
  end

end
