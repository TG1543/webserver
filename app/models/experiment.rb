class Experiment < ApplicationRecord
  belongs_to :project
  belongs_to :state
  belongs_to :result

  has_many :user_experiments
  has_many :users, through: :user_experiments

  def add_users(users)
    experiment = self
    users.each do |user|
      experiment.user_experiments.build(user.id)
    end
    self.save
  end

end
