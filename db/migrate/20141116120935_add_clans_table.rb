class AddClansTable < ActiveRecord::Migration
  def change
		create_table :clans do |t|
			t.text :description
			t.string :motto
			t.string :name
			t.string :tag
			t.integer :status

			t.timestamps
		end
		change_column :clans, :id, 'bigint'
  end
end
