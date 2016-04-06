class Comment < ActiveRecord::Base
  require 'pusher'
  belongs_to :user
  belongs_to :event

  validates_presence_of :content

  before_save :push_notification

  def recent
    if self.created_at >= Time.now - 60*60*24
      return self
    end
  end

  def push_notification
    pusher_client = Pusher::Client.new(
      app_id: '194717',
      key: 'c7a6150d22d40eea7bca',
      secret: '76c36e83b489767cef0a',
      encrypted: true
    )

    pusher_client.trigger('test_channel', 'my_event', {
      message: 'Comment'
    })
  end


end
