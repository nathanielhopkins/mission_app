class Cheer < ApplicationRecord
  validates :goal_id, uniqueness: { scope: :giver_id }
end
