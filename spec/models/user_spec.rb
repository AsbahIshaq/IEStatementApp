require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'password encryption' do
    let(:user) { create(:user, password: 'password123', password_confirmation: 'password123') }

    it 'encrypts the password' do
      expect(user.password_digest).not_to eq('password123')
    end

    it 'authenticates with valid password' do
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'does not authenticate with invalid password' do
      expect(user.authenticate('invalid_password')).to eq(false)
    end
  end

  describe '#generate_token' do
    let(:user) { create(:user) }

    it 'generates a JWT token' do
      token = user.generate_token
      decoded_token = JWT.decode(token, Rails.application.secret_key_base)
      expect(decoded_token.first['user_id']).to eq(user.id)
    end
  end
end
