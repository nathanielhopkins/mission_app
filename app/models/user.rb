class User < ApplicationRecord
  validates :username, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true}

  after_initialize :ensure_session_token

  attr_reader :password

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  private
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
end
