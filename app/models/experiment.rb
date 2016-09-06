class Experiment < ApplicationRecord
  belongs_to :project
  belongs_to :state
  belongs_to :result, optional: true
  has_one :user, through: :project

  has_many :user_experiments
  has_many :users, through: :user_experiments
  has_many :iterations

  def add_users(users = [])
    experiment = self
    users.each do |user|
      experiment.user_experiments.build(user)
    end
    self.save
  end

  def is_canceled?
    self.state == State.canceled
  end

end
