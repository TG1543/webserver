class UserExperiment < ApplicationRecord
  belongs_to :user
  belongs_to :experiment, dependency: :nullify
end
