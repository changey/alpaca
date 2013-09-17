class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :fbid
      t.string :name
      t.string :email
      t.string :gender
      t.string :token

      t.timestamps
    end
  end
end
