class Rol < ApplicationRecord
  before_save { self.active = "true" }
  validates :rol,  presence: true
  has_many :users
end
