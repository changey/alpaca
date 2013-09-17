class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.string :category
      t.float :rate
      t.integer :user_id
      t.integer :profile_id

      t.timestamps
    end
  end
end
