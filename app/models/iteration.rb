class Iteration < ApplicationRecord
  belongs_to :experiment
  has_many :binnacles
  has_one :binnacle, optional: true

  def add_comment(comment_params)
    comment = self.binnacles.build(comment_params)
    self.save
  end
end
