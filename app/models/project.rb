class Project < ApplicationRecord
   validates :name, :user_id, presence: true
   validates :description, length: { in: 10..255 }
   default_scope { order(created_at: :desc) }

   belongs_to :user
   belongs_to :state
   has_many :experiments, dependent: :destroy

   after_update :cancel_experiments
   after_update :finish_experiments

   def is_canceled?
       self.state_id.to_s == State.canceled.to_s
   end

   def is_finished?
       self.state_id.to_s == State.finished.to_s
   end

   def cancel_experiments
     if self.is_canceled?
       experiments.each {|experiment| experiment.cancel}
     end
   end

   def finish_experiments
     if self.is_finished?
       experiments.each {|experiment| experiment.finish}
     end
   end
end
