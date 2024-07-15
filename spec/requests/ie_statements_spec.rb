require 'rails_helper'

RSpec.describe IeStatementsController, type: :request do
  let!(:user) { create(:user) }
  let!(:token) { JsonWebToken.encode(user_id: user.id) }
  let!(:headers) { { 'Authorization' => token } }

  describe 'POST /users/:user_id/ie_statements' do
    context 'with valid params' do
      let(:valid_params) do
        {
          ie_statement: {
            month: 'july',
            income: [{ name: 'Salary', amount: 2800 }],
            expenditure: [{ name: 'Rent', amount: 1500 }]
          }
        }
      end

      it 'creates a new IeStatement' do
        post "/users/#{user.id}/ie_statements", params: valid_params, headers: headers
        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)

        expect(json_response['month']).to eq('july')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          ie_statement: {
            month: 'july',
            income: [{ name: 'Salary', amount: nil }],
            expenditure: [{ name: 'Rent', amount: 1500 }]
          }
        }
      end

      it 'returns unprocessable entity status' do
        post "/users/#{user.id}/ie_statements", params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /users/:user_id/ie_statements' do
    before do
      create_list(:ie_statement, 3, user: user)
    end

    it 'returns a list of IeStatements' do
      get "/users/#{user.id}/ie_statements", headers: headers
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)

      expect(json_response.size).to eq(3)
    end
  end

  describe 'GET /users/:user_id/ie_statements/:id' do
    let!(:ie_statement) { create(:ie_statement, user: user) }

    it 'returns an IeStatement' do
      get "/users/#{user.id}/ie_statements/#{ie_statement.id}", headers: headers
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)

      expect(json_response['id']).to eq(ie_statement.id)
    end
  end

  describe 'GET /users/:user_id/ie_statements/monthly_statement' do
    let!(:ie_statement) { create(:ie_statement, user: user, month: 'july') }

    it 'returns the monthly IeStatement' do
      get "/users/#{user.id}/ie_statements/monthly_statement?month=july", headers: headers
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)

      expect(json_response['month']).to eq('july')
    end
  end

  describe 'GET /users/:user_id/ie_statements/monthly_statement_download' do
    let(:month) { 'july' }
    let(:ie_statement) { create(:ie_statement, user: user, month: month) }
    let!(:headers) { { 'Authorization' => token, 'Accept' => 'text/csv' } }

    it 'sends CSV data for monthly statement download' do
      ie_statement
      get "/users/#{user.id}/ie_statements/monthly_statement_download?month=#{month}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq("Income,Amount,Expenditure,Amount\n")
      expect(response.headers['Content-Disposition']).to include("filename=\"ie_statement_#{month}.csv\"")
    end
  end
end
