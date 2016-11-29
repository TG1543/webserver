class AddIndexToSerialNumberOfEquipment < ActiveRecord::Migration[5.0]
  def change
    add_index :equipment, :serial_number, :unique => true
  end
end
