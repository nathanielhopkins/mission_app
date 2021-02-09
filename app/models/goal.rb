class Goal < ApplicationRecord
  include Commentable

  validates :user_id, presence: true
  validates :title, presence: true, length: { minimum: 6 }

  belongs_to :user

  has_many :cheers
end
