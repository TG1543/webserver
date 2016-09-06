class Iteration < ApplicationRecord
  belongs_to :experiment
  has_many :binnacles
  has_one :binnacle
  has_one :plot


  def add_comment(comment_params)
    comment = self.build_binnacle(comment_params)
    self.save
  end

  def add_plot(plot_params)
    plot = self.build_plot(plot_params)
    self.save
  end

end
