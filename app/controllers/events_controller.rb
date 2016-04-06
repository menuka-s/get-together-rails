class EventsController < ApplicationController
  include UsersHelper
  include EventsHelper
  require 'csv'
  require 'json'

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

  def comments_ajax
    @event = Event.find(params[:id])
    render partial: 'comment/showallevent'
  end

  def new
    @event = Event.new
    @activity = Activity.new
    @activities = Activity.all
  end

  def create
    @event = current_user.created_events.new(event_params)
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

  def graph_data
    event = Event.find(params[:id])
    uas = []
    a = []
    # data = []
    event.joined_users.each {|user| uas << Activity.all - user.disliked_activities}
    uas.flatten.each {|ua| a << ua.name}
    act_freq = Hash.new(0);
    a.each { |act| act_freq[act] += 1 }
    i = 0
    data = "name,id,foo,total_amount,group,color\n"
    act_freq.each do |k,v| 
      color = "#215852"
      color = "#00695C" if v > 7
      color = "#028E7F" if v > 8
      group = "low"
      group = "medium" if v > 7
      group = "high" if v > 8
      data << "#{k},#{Activity.find_by_name(k).id},0,#{v},#{group},#{color}\n"
    end
    render plain: data
  end 

  private
  def event_params
    params.require(:event).permit(:name, :description, :date, :location_name, :address, :activity_name, :max_participants)
  end

  def index_locals
    [ [ current_user.latitude, current_user.longitude ],
        current_user.appealing_events,
        current_user.appealing_events_by_date,
        current_user.appealing_events_by_proximity
    ]
  end

end
