class User < ApplicationRecord
  include Commentable
  
  validates :username, :password_digest, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true}

  after_initialize :ensure_session_token

  attr_reader :password

  has_many :goals, 
    dependent: :destroy,
    class_name: :Goal,
    foreign_key: :user_id


  has_many :cheers_given, 
    class_name: :Cheer,
    foreign_key: :giver_id
  
  has_many :cheers_received,
    through: :goals,
    source: :cheers

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save
    self.session_token
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)

    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  #GOALS

  def completed_goals
    completed = self.goals.where(completed: true)
  end

  def uncompleted_goals
    uncompleted = self.goals.where(completed: false)
  end

  #CHEERS

  def decrement_cheer_count!
    self.cheer_count = self.cheer_count - 1
    self.save!
  end
  
  private
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
end
