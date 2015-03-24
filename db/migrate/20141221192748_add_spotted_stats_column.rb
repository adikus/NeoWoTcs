class AddSpottedStatsColumn < ActiveRecord::Migration
  def change
    add_column :player_stats, :spotted, :integer
  end
end
