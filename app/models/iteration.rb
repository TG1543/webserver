class Iteration < ApplicationRecord
  belongs_to :experiment
  has_many :binnacles
  has_one :binnacle

  def add_comment(comment_params)
    comment = self.binnacles.build(comment_params)
    self.save
    self.binnacle_id = comment.id
    self.save
  end
end
