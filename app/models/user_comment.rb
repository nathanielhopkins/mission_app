class UserComment < ApplicationRecord
  validates :author_id, :user_id, :body, presence: true
end
