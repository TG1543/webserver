class ChangeColumnBinnacleIdInsteadComment < ActiveRecord::Migration[5.0]
  def change
    rename_column :iterations, :comment, :binnacle_id
  end
end
