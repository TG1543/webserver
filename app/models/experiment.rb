class Experiment < ApplicationRecord
  belongs_to :project
  belongs_to :state
  belongs_to :result, optional: true
  has_one :user, through: :project

  has_many :user_experiments
  has_many :users, through: :user_experiments
  has_many :iterations

  after_update :update_interations

  def add_users(users = [])
    experiment = self
    users.each do |user|
      experiment.user_experiments.build(user)
    end
    self.save
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
    update(state_id: State.canceled)
    iterations.each {|iteration| iteration.cancel }
  end

  def finish
    update(state_id: State.finished)
    iterations.each {|iteration| iteration.finish }
  end

end
