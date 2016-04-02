class UsersController < ApplicationController

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def logout
    session[:user_id]=nil
  end

  def interests
    @user = User.find(params[:id])
  end

  def allinterests
    @user = User.find(params[:id])
    @categories = Category.all
    puts "adding categories"
    @categories.each do |category|
      UsersCategory.create(user_id: @user.id, category_id: category.id)
    end
    redirect_to @user
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



end
