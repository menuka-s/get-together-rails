class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :event


  def recent
    if self.created_at >= Time.now - 60*60*24
      return self
    end
  end


end
