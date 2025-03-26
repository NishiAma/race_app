require 'rails_helper'

RSpec.describe Api::V1::StudentsController, type: :controller do
  describe 'GET #index' do
    let!(:students) { create_list(:student, 3) }

    before do
      get :index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns all students' do
      expect(JSON.parse(response.body).size).to eq(3)
    end

    it 'returns students with correct attributes' do
      json_response = JSON.parse(response.body)
      expect(json_response.first.keys).to match_array(%w[id name age created_at updated_at])
    end
  end
end 