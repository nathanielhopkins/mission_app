class Goal < ApplicationRecord
  validates :user_id, :title, :private, :completed, presence: true

  belongs_to(
    :user,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )
end
