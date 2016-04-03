class CommentsController < ApplicationController
  include UsersHelper


  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @event = Event.find(params[:event_id])
    @comment.event_id = @event.id
    @comment.save
    redirect_to @event
  end


private
  def comment_params
    params.require(:comment).permit(:content)
  end


end
