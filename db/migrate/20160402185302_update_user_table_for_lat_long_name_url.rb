class UpdateUserTableForLatLongNameUrl < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
    end
  end
end
