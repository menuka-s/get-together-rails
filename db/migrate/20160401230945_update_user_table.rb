class UpdateUserTable < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :facebook_id
      t.integer :points
      t.string :last_location
    end
  end
end
