class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :fbid
      t.text :total_ratings, :null => :false, :default => '{}'

      t.timestamps
    end
  end
end
