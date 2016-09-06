class CreatePlots < ActiveRecord::Migration[5.0]
  def change
    create_table :plots do |t|
      t.string :name
      t.string :x_axis
      t.string :y_axis
      t.references :iteration, foreign_key: true

      t.timestamps
    end
  end
end
