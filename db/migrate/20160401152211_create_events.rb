usclass CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text  :name, null: false
      t.text :description, null: false
      t.integer :creator_id, null: false
      t.datetime :date, null: false
      t.string :location_name
      t.string :address, null: false
      t.float :latitude
      t.float  :longitude
      t.integer :activity_id, null: false

      t.timestamps null: false
    end
  end
end
