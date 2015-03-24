class AddPlayerStatsTable < ActiveRecord::Migration
  def change
    create_table :player_stats do |t|
      t.integer :player_id
      t.integer :battles
      t.integer :wins
      t.integer :defeats
      t.integer :survived
      t.integer :frags
      t.float :accuracy
      t.integer :damage
      t.integer :capture
      t.integer :defense
      t.integer :experience
      t.float :wn8
      t.float :efficiency
      t.float :average_tier
      t.float :sc3

      t.timestamps
    end
    change_column :player_stats, :player_id, 'bigint'
  end
end
