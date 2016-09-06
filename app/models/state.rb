class State < ApplicationRecord
  validates :value,  presence: true
  has_many :projects

  def self.canceled
    2
  end
end
