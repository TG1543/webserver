class AddDateToBinnacle < ActiveRecord::Migration[5.0]
  def change
    add_column :binnacles, :date, :date
  end
end
