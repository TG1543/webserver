class AddActiveStatusNameRolIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :active, :boolean
    add_column :users, :rol_id, :integer
    add_index :users, :rol_id
  end
end
