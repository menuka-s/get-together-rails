module UsersHelper

  def current_user
    @current_user ||= session[:user_id] && User.find_by_id(session[:user_id])
  end

  def is_interested?(category, user)
    user.liked_categories.include?(category)
  end

  def dislikes_this?(activity, user)
    user.disliked_activities.include?(activity)
  end

  def current_user_activities
    user_activities = Activity.all - current_user.disliked_activities
    user_arr =  user_activities.map { |activity| activity.name }
    return user_arr.join(",")
  end

end
