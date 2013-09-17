class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id, :null => false
      t.integer :comment_id, :null=>false

      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, :comment_id
  end
end
