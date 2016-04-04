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
    params.require(:event).permit(:name, :description, :date, :location_name, :address, :activity_id, :max_participants)
  end

  def index_locals
    [ [ current_user.latitude, current_user.longitude ],
        current_user.appealing_events,
        current_user.appealing_events_by_date,
        current_user.appealing_events_by_proximity
    ]
  end

end
