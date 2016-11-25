class UserExperiment < ApplicationRecord
  belongs_to :user
  belongs_to :experiment, dependent: :destroy
end
