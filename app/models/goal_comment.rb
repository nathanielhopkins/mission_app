class GoalComment < ApplicationRecord
  validates :author_id, :goal_id, :body, presence: true

  
end
