class Iteration < ApplicationRecord
  belongs_to :experiment
  has_many :binnacles
  has_one :plot


  def add_comment(comment_params)
    comment = self.binnacles.build(comment_params)
    self.save
  end

  def add_plot(plot_params)
    plot = self.build_plot(plot_params)
    self.save
  end

  def last_comment
    self.binnacles.last
  end

end
