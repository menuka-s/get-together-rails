class AddMilePreferenceToUserTable < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :mile_preference
    end
  end
end
