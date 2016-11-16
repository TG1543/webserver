class Equipment < ApplicationRecord
  belongs_to :iteration, optional: true

  validates :serial_number, uniqueness: true
  default_scope { order(created_at: :desc) }
  has_many :values


  def is_active?
    self.active
  end

end
