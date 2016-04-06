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
        # redirect user back to event page with event errors showing
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
          # redirect user back to new event page with event errors (the new activity has been saved to the db)
          @activities = Activity.all
          render new_event_path(@event)
        end

      else # the activity did not pass validation
        # redirect user back to new event page with activity errors showing (the new activity has not been saved to the db, so the categories checkbox div will be shown)

        new_event_params.delete("all_category_ids")
        @event = current_user.created_events.new(new_event_params)

        if !@activity.errors.messages.include?(:name)
          @new_activity_flag = "flag" # create a flag variable to determine whether the categories checkboxes will be shown upon page load
        else
          # update the activity name error message so it specifies the activity must have a name
          @activity.errors.messages["Activity name"] = ["can't be blank"]
          @activity.errors.messages.delete(:name)
        end

        @activity.errors.messages.each do |key,value|
          @event.errors.add(key,value.first)
        end

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
    new_event_params = event_params

    @activity = Activity.find_or_initialize_by(name: new_event_params[:activity_name])
    @activity.all_categories = new_event_params[:all_category_ids]
    @activity.save

    new_event_params.delete("all_category_ids")
    @event.update(new_event_params)
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
