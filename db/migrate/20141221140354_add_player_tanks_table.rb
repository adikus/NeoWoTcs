class AddPlayerTanksTable < ActiveRecord::Migration
  def change
    create_table :player_tanks do |t|
      t.integer :player_id
      t.integer :tank_id
      t.integer :battles
      t.integer :wins
      t.integer :mark_of_mastery

      t.timestamps
    end
    change_column :player_tanks, :player_id, 'bigint'
  end
end
