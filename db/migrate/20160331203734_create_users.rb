class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.text :bio
      t.string :image_url, null: false
      t.string :facebook_id, null: false
      t.integer :points
      t.string :last_location

      t.timestamps null: false
    end
  end
end
