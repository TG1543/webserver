class Binnacle < ApplicationRecord
    belongs_to :iteration
    default_scope { order(created_at: :desc) } 
end
