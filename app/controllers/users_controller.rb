class UsersController < ApplicationController



  def index

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

  def show
    @user = User.find(params[:id])
  end


end
