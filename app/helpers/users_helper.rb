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

  def mutual_interests(user)
    user_interests = user.appealing_activities
    mutual_interests = user_interests & current_user.appealing_activities
  end

  def recommendations(event)
    amount_in_common = 0
    current_user_interests = Activity.all - current_user.disliked_activities
    creator_interests = Activity.all - event.creator.disliked_activities
    event_participant_count = 0
    event.joined_users.each do |event_participant|
      if event_participant != current_user
        event_participant_interests = Activity.all - event_participant.disliked_activities
        amount_in_common += (current_user_interests & event_participant_interests).length
        event_participant_count += 1
      end
    end
    amount_in_common += (current_user_interests & creator_interests).length*1.3
    amount_in_common / (event_participant_count + 1)
  end

  def top_activities
    recommended_activities = []
    recommended_activities = Event.all.map{|event| event if event.creator != current_user}.compact
    # recommended_activities = recommended_activities.compact
    recommended_activities = recommended_activities.map{ |event| event if event.date > Time.now}
    recommended_activities = recommended_activities.compact
    recommended_activities.sort! { |a,b| recommendations(a) <=> recommendations(b) }
    p recommended_activities
    if recommended_activities.length >= 3
      return recommended_activities[0..2]
    else
      return recommended_activities
    end

  end

end
