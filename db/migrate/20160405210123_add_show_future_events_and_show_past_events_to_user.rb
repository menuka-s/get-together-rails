class AddShowFutureEventsAndShowPastEventsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :show_future_events, :bool, default: true
  	add_column :users, :show_past_events, :bool, default: true
  end
end
