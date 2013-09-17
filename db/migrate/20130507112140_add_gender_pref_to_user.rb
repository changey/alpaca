class AddGenderPrefToUser < ActiveRecord::Migration
  def change
    add_column :users, :gender_pref, :string
  end
end
