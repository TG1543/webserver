class RemoveBinnacleIdColumnFromIteration < ActiveRecord::Migration[5.0]
  def change
    remove_column :iterations, :binnacle_id
  end
end
