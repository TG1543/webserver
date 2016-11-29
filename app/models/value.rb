class Value < ApplicationRecord
  after_create :assign_equipment
  belongs_to :parameter
  belongs_to :equipment, optional: true
  belongs_to :iteration



  private
  def assign_equipment
    equipment= self.iteration.equipment
    self.equipment= equipment
  end

end
