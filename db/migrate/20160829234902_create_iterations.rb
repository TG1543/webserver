class CreateIterations < ActiveRecord::Migration[5.0]
  def change
    create_table :iterations do |t|
      t.references :experiment, foreign_key: true
      t.date :started_at
      t.date :ended_at
      t.text :comment

      t.timestamps
    end
  end
end
