class User < ApplicationRecord
	before_save { email.downcase! }
	VALID_NAME_REGEX = /\A[a-zA-Z]+(?: [a-zA-Z]+)?\z/
	validates :fastName, absence: true, length: { maximum: 30 }, format: { with: VALID_NAME_REGEX }, allow_nil: true, allow_blank: true
	validates :lastName, absence: true, length: { maximum: 30 }, format: { with: VALID_NAME_REGEX }, allow_nil: true, allow_blank: true

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, 	 presence: true, length: { maximum: 30 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

	VALID_PHONE_REGEX = /A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{3})?\)?[- ]?\d{3}[- ]?\d{4}\z/
	validates :phone, 	 absence: true, length: { maximum: 15 }, format: { with: VALID_PHONE_REGEX }, numericality: true, allow_nil: true, allow_blank: true

	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }

	# Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
