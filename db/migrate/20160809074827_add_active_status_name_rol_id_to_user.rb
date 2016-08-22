class AddActiveStatusNameRolIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :active, :boolean
    add_column :users, :role_id, :integer
    add_index :users, :role_id
  end
end
