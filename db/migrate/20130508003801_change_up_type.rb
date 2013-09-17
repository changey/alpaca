class ChangeUpType < ActiveRecord::Migration
  def up
    change_column :votes, :up, :string, :default=>"true"
  end

  def down
    change_column :votes, :up, :boolean
  end
end
