class Cheer < ApplicationRecord
  validates :goal_id, uniqueness: { scope: :giver_id }

  belongs_to :goal

  belongs_to :giver, class_name: :User
end
