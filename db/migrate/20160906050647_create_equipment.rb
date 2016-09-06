class CreateEquipment < ActiveRecord::Migration[5.0]
  def change
    create_table :equipment do |t|
      t.references :iteration, foreign_key: true
      t.boolean :active, default:  true
      t.string :name

      t.timestamps
    end
  end
end
