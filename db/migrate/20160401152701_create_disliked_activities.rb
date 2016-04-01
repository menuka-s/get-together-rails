class CreateDislikedActivities < ActiveRecord::Migration
  def change
    create_table :users_activities do |t|
      t.integer :user_id, null: false
      t.integer :activity_id, null: false

      t.timestamps null: false
    end
  end
end
