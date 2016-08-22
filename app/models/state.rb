class State < ApplicationRecord
  validates :value,  presence: true
  has_many :projects
end
