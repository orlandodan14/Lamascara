class User < ApplicationRecord
	attr_accessor :remember_token
	before_save { email.downcase! }
	VALID_NAME_REGEX = /\A[a-zA-Z]+(?: [a-zA-Z]+)?\z/
	validates :fastName, absence: true, length: { maximum: 30 }, format: { with: VALID_NAME_REGEX }, allow_nil: true, allow_blank: true
	validates :lastName, absence: true, length: { maximum: 30 }, format: { with: VALID_NAME_REGEX }, allow_nil: true, allow_blank: true

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, 	 presence: true, length: { maximum: 30 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

	VALID_PHONE_REGEX = /A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/
	validates :phone, 	 absence: true, length: { maximum: 15 }, format: { with: VALID_PHONE_REGEX }, numericality: true, allow_nil: true, allow_blank: true

	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

	# METHODS:
	# Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

	  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
end