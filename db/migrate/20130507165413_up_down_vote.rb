class UpDownVote < ActiveRecord::Migration
  def change
    add_column :votes, :up, :boolean, :default => true, :null=>false     # true for upvote, false for downvote; field must exist
  end
end
