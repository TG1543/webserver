class Iteration < ApplicationRecord
  belongs_to :experiment

  has_many :values, dependent: :destroy
  has_many :binnacles, dependent: :destroy

  has_many :plots, dependent: :destroy
  has_one :equipment
  validate :validate_experiment

  after_update :_unassign_equipment

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
    return true if equipment == nil
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
      self.state_id.to_s == State.canceled.to_s
  end

  def is_finished?
      self.state_id.to_s == State.finished.to_s
  end

  def _unassign_equipment
    if (!self.is_canceled? && !self.is_finished?)
      unassign_equipment
    end
  end

  def cancel
      unassign_equipment
      update(state_id: State.canceled) if !self.is_finished?
  end

  def finish
      unassign_equipment
      update(state_id: State.finished) if !self.is_canceled?
  end

  private

    def validate_experiment
         errors.add(:experiment,"El experimento está cancelado") if self.experiment.is_canceled?
    end

end
