class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.references :user
      t.references :profile

      t.timestamps
    end
    add_index :comments, :profile_id
    add_index :comments, :user_id
  end
end
