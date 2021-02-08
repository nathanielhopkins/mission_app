class GoalComment < ApplicationRecord
  validates :author_id, :goal_id, :body, presence: true

  belongs_to(
    :author,
    class_name: "User",
    foreign_key: :author_id,
    primary_key: :id
  )

  belongs_to(
    :goal,
    class_name: "Goal",
    foreign_key: :goal_id,
    primary_key: :id
  )
end
