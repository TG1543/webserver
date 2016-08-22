class Experiment < ApplicationRecord
  belongs_to :project
  belongs_to :state
  belongs_to :result

  has_many :user_experiments
  has_many :user, through: :user_experiments
end
