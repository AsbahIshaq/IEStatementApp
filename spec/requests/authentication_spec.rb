require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let!(:user) { create(:user, email: 'test@example.com', password: 'password') }

  describe 'POST /auth/login' do
    it 'authenticates the user' do
      post '/auth/login', params: { auth: { email: 'test@example.com', password: 'password' } }
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['token']).not_to be_nil
    end

    it 'returns an error when email is invalid' do
      post '/auth/login', params: { auth: { email: 'invalid@example.com', password: 'password' } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns an error when password is invalid' do
      post '/auth/login', params: { auth: { email: 'test@example.com', password: 'invalid' } }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
