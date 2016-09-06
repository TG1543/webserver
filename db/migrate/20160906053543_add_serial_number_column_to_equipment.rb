class AddSerialNumberColumnToEquipment < ActiveRecord::Migration[5.0]
  def change
    add_column :equipment, :serial_number, :string
  end
  add_index :equipment, :serial_number, :unique => true
end
