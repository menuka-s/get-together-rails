class UsersController < ApplicationController
  include UsersHelper

  def index
  end



  def show
    @user = User.find(params[:id])
  end

  def new
    if session[:user_id]
      @user = User.find(session[:user_id])
      @current_location = [ current_user.latitude, current_user.longitude ]
      @user_appealing_events = current_user.appealing_events
      @user_appealing_events_by_date = current_user.appealing_events_by_date
      @user_appealing_events_by_proximity = current_user.appealing_events_by_proximity

      render :template => "events/index"
    else
      render "users/new"
    end
  end

  def logout
    session[:user_id]=nil
  end

  def interests
    @user = User.find(params[:id])
    @categories = Category.all
  end

  def allinterests
    @user = User.find(params[:id])
    @categories = Category.all
    puts "adding categories"
    @categories.each do |category|
      UsersCategory.create(user_id: @user.id, category_id: category.id)
    end
    @user.disliked_activities.delete_all
    redirect_to @user
  end

  def create
    @user = User.find_or_initialize_by(email: params["email"])
    if @user.image_url == nil
      @user.image_url = params["image_url"]
      @user.bio = ""
      @user.points = 0
      @user.name = params["name"]
      @user.longitude = params["longitude"]
      @user.latitude = params["latitude"]
      @user.facebook_id = params["facebook_id"]
      @user.save
      session[:user_id] = @user.id
    else
      session[:user_id] = @user.id
      @user.longitude = params["longitude"]
      @user.latitude = params["latitude"]
      @user.save
    end
    render json: {user_id: @user.id, like_count: @user.liked_categories.length}
  end

  def ajax_join_event
    if session[:user_id] == nil
      render json: {"status"=>"💩"}
    else
      event = Event.find(params[:id])
      user = User.find(session[:user_id])
      if !user.joined_events.include?(event)
        user.joined_events << event
        render json: {"status"=>"1"}
      else
        user.joined_events.delete(event)
        render json: {"status"=>"0"}
      end
    end
  end


  def interests_handler #not restful, not pretty. but works splendidly.
    (action,user_id,category_id) = params[:data].split(',')
    if (action == "a")
      userLike = UsersCategory.new({user_id: user_id, category_id: category_id})
      if userLike.save
        render json: {action:"a", user_id: user_id, category_id: category_id}
      else
        render json: "error"
      end
    elsif (action == "r")
      userLike = UsersCategory.find_by(user_id: user_id, category_id: category_id)
      if userLike.destroy
        render json: {action:"r", user_id: user_id, category_id: category_id}
      else
        render json: "error"
      end
    end
  end

  def activity_dislikes_handler
    (action,user_id,activity_id) = params[:data].split(',')

    if (action == "a")
      userLike = UsersActivity.new({user_id: user_id, activity_id: activity_id})
      if userLike.save
        render json: {action:"a", user_id: user_id, activity_id: activity_id}
      else
        render json: "error"
      end
    elsif (action == "r")
      userLike = UsersActivity.find_by(user_id: user_id, activity_id: activity_id)
      if userLike.destroy
        render json: {action:"r", user_id: user_id, activity_id: activity_id}
      else
        render json: "error"
      end
    end
  end


end
