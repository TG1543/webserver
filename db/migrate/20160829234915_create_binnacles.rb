class CreateBinnacles < ActiveRecord::Migration[5.0]
  def change
    create_table :binnacles do |t|
      t.references :iteration, foreign_key: true
      t.text :comment

      t.timestamps
    end
  end
end
