class Role < ApplicationRecord
  validates :value,  presence: true
  has_many :users
end
