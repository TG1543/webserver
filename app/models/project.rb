class Project < ApplicationRecord
   validates :name, :user_id, presence: true
   validates :description, length: { in: 10..255 }

   belongs_to :user
   belongs_to :state
   has_many :experiments

   def is_canceled?
       self.state_id.to_s == State.canceled.to_s
   end
end
