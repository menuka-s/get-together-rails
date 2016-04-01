class CreateActivityCategories < ActiveRecord::Migration
  def change
    create_table :activity_categories do |t|
      t.integer :activity_id, null: false
      t.integer :category_id, null: false

      t.timestamps null: false
    end
  end
end
