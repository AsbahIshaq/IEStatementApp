class User < ApplicationRecord
  has_many :ie_statements, dependent: :destroy
  validates :name, :email, presence: true
  validates :email, uniqueness: true

  has_secure_password

  def generate_token
    JWT.encode({ user_id: id }, Rails.application.secret_key_base)
  end
end
