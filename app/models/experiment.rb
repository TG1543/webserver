class Experiment < ApplicationRecord
  belongs_to :project
  belongs_to :state
  belongs_to :result, optional: true
  has_one :user, through: :project

  has_many :user_experiments
  has_many :users, through: :user_experiments
  has_many :iterations, dependent: :destroy

  default_scope { order(created_at: :desc) } 

  after_update :update_interations

  validate :validate_project

  def add_user(user_id)
    self.user_experiments.create(user_id: user_id)
  end

  def remove_user(user_id)
    self.user_experiments.where(user_id: user_id).last.destroy
  end

  def is_canceled?
    self.state_id.to_s == State.canceled.to_s
  end

  def is_finished?
    self.state_id.to_s == State.finished.to_s
  end

  def update_interations
    if self.is_finished?
      iterations.each {|iteration| iteration.finish }
    elsif self.is_canceled?
      iterations.each {|iteration| iteration.cancel }
    end
  end

  def cancel
    update(state_id: State.canceled) if !self.is_finished?
    iterations.each {|iteration| iteration.cancel if !iteration.is_finished?} if !self.is_finished?
  end

  def finish
    update(state_id: State.finished) if !self.is_canceled?
    iterations.each {|iteration| iteration.finish if !iteration.is_canceled? } if !self.is_canceled?
  end
  private
  def validate_project
    errors.add(:project,"El proyecto está cancelado") if self.project.is_canceled?
  end

end
