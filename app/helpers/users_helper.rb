module UsersHelper

  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    end
  end

  def is_interested?(category, user)
    user.liked_categories.include?(category)
  end

end
