class UsersController < ApplicationController

  def index

  end

  def create
    puts "******"
    puts params["email"]
    puts "******"
    @user = User.find_or_create_by(email: params["email"])
    if @user.image_url == nil
      @user.image_url = params["image_url"]
      @user.facebook_id = params["facebook_id"]
      @user.save
      session[:user_id] = @user.id
    else
      session[:user_id] = @user.id
    end
    redirect_to @user
  end

  def show
    @user = User.find(params[:id])
  end


end
