class AddPlayersTable < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :clan_id
      t.integer :status
      t.string :role

      t.timestamps
    end
    change_column :players, :id, 'bigint'
    change_column :players, :clan_id, 'bigint'
  end
end
