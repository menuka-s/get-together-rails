class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :description, null: false
      t.integer :creator_id, null: false
      t.datetime :date, null: false
      t.string :location_name, null: false
      t.string :location, null: false
      t.integer :activity_id, null: false

      t.timestamps null: false
    end
  end
end
