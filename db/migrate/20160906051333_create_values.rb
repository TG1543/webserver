class CreateValues < ActiveRecord::Migration[5.0]
  def change
    create_table :values do |t|
      t.float :quantity
      t.references :parameter, foreign_key: true
      t.references :equipment, foreign_key: true
      t.references :iteration, foreign_key: true

      t.timestamps
    end
  end
end
