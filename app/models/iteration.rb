class Iteration < ApplicationRecord
  belongs_to :experiment

  has_many :values
  has_many :binnacles

  has_one :plot
  has_one :equipment

  def add_comment(comment_params)
    comment = self.binnacles.build(comment_params)
    self.save
  end

  def last_comment
    self.binnacles.last
  end

  def add_plot(plot_params)
    plot = self.build_plot(plot_params)
    self.save
  end

  def assign_equipment(equipment_id)
    equipment = Equipment.where(id: equipment_id).first
    return false unless equipment && equipment.is_active?
    equipment.iteration_id = self.id
    values = self.values
    Iteration.transaction do
      equipment.save
      values.each do |value|
          value.equipment = equipment
          value.save
      end
    end
  end

  def unassign_equipment
    equipment.iteration_id = nil
    values = self.values
    Iteration.transaction do
      equipment.save
      values.each do |value|
          value.equipment = nil
          value.save
      end
    end
  end

  def add_values_to_equipment(values)
    Value.transaction do
      values.each do |value|
        self.add_value_to_parameter(value.parameter_id,value.quantity)
      end
    end
  end

  def add_value_to_parameter(parameter_id,quantity)
      value = Value.where(parameter_id: parameter_id,iteration_id: self.id).first
      value.quantity = quantity if value
      value = self.values.build(parameter_id: parameter_id, quantity: quantity) unless value
      value.save
  end

  def is_canceled?
    self.state == State.canceled
  end

end
