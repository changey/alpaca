class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id, :null => false
      t.integer :profile_id, :null=>false

      t.timestamps
    end

    add_index :favorites, :user_id
    add_index :favorites, :profile_id
  end
end
