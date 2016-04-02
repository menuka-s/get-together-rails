class UsersController < ApplicationController

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def logout
    reset_session
  end

  def create
    puts "++++++++++++++++++"
    puts "params:"
    puts params
    puts "++++++++++++++++++"
    @user = User.find_or_initialize_by(email: params["email"])
    if @user.image_url == nil
      @user.image_url = params["image_url"]
      @user.bio = ""
      @user.points = 0
      @user.last_location = ""
      @user.facebook_id = params["facebook_id"]
      @user.save
      session[:user_id] = @user.id
    else
      session[:user_id] = @user.id
    end
    render json: @user.id
  end

  def ajax_join_event
    if session[:user_id] == nil
      render json: {"status"=>"poop"}
    else
      event = Event.find(params[:id])
      user = User.find(session[:user_id])
      if !user.joined_events.include?(event)
        user.joined_events << event
        render json: {"status"=>"ok"}
      else
        render json: {"status"=>"poop"}
      end
    end
  end



end
