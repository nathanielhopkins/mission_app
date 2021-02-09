class Goal < ApplicationRecord
  include Commentable

  validates :user_id, presence: true
  validates :title, presence: true, length: { minimum: 6 }

  belongs_to(
    :user,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )
end
