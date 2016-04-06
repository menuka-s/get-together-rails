class CommentsController < ApplicationController
  include UsersHelper
  require 'json'
  include ActionView::Helpers::DateHelper

  def create
    if request.xhr?
      @event = Event.find(params[:event_id])
      @comment = Comment.new(content: params[:content], event_id: params[:event_id], commenter: current_user)
      @comment.save
      comment_time = distance_of_time_in_words_to_now(@comment.created_at)
      # render json: {content: @comment.content, userimage: current_user.image_url,username:current_user.name, timeago: comment_time}
        render :"comment/_new", :layout => false, :locals => {facebook_id: current_user.facebook_id, content: @comment.content, userimage: current_user.image_url,username:current_user.name, timeago: comment_time, event: @event, comment: @comment}
    else
      @comment = Comment.new(comment_params)
      @comment.user_id = current_user.id
      @event = Event.find(params[:event_id])
      @comment.event_id = @event.id
      @comment.save
      redirect_to @event
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    if request.xhr?
    else
      redirect_to @event
    end
  end


private
  def comment_params
    params.require(:comment).permit(:content)
  end


end
