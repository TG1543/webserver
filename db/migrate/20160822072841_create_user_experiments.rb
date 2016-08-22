class CreateUserExperiments < ActiveRecord::Migration[5.0]
  def change
    create_table :user_experiments do |t|
      t.references :user, foreign_key: true
      t.references :experiment, foreign_key: true

      t.timestamps
    end
  end
end
