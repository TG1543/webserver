class AddSerialNumberColumnToEquipment < ActiveRecord::Migration[5.0]
  def change
    add_column :equipment, :serial_number, :string
  end
end
