class Goal < ApplicationRecord
  validates :user_id, presence: true
  validates :title, presence: true, length: { minimum: 6 }

  belongs_to(
    :user,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :comments,
    dependent: :destroy,
    class_name: "GoalComment",
    foreign_key: :goal_id,
    primary_key: :id
  )
end
