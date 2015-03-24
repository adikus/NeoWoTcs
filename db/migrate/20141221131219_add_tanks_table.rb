class AddTanksTable < ActiveRecord::Migration
  def change
    create_table :tanks do |t|
      t.string :name
      t.string :name_i18n
      t.string :nation
      t.string :tank_type
      t.integer :level
      t.string :contour_image

      t.timestamps
    end
  end
end
