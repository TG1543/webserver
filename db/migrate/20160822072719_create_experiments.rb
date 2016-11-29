class CreateExperiments < ActiveRecord::Migration[5.0]
  def change
    create_table :experiments do |t|
      t.string :description
      t.references :project, foreign_key: true
      t.references :state, foreign_key: true, default: 1
      t.references :result, foreign_key: true

      t.timestamps
    end
  end
end
