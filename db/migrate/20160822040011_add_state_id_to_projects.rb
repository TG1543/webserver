class AddStateIdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_reference :projects, :state, foreign_key: true,default: 1
  end
end
