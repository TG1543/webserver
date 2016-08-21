class Rol < ApplicationRecord
  validates :rol,  presence: true
  has_many :users
end
