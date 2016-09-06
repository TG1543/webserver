class Equipment < ApplicationRecord
  belongs_to :iteration, optional: true

  has_many :values

  def is_active?
    self.active
  end
  
end
