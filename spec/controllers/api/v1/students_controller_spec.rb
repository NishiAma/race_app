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

  describe 'GET #show' do
    let!(:student) { create(:student) }

    context 'when student exists' do
      before { get :show, params: { id: student.id } }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the correct student' do
        expect(JSON.parse(response.body)['id']).to eq(student.id)
      end
    end

    context 'when student does not exist' do
      before { get :show, params: { id: 'non-existent' } }

      it 'returns http not found' do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        student: {
          name: 'John Doe',
          age: 20
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new student' do
        expect {
          post :create, params: valid_attributes
        }.to change(Student, :count).by(1)
      end

      it 'returns http created' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          student: {
            name: '',
            age: nil
          }
        }
      end

      it 'does not create a new student' do
        expect {
          post :create, params: invalid_attributes
        }.to change(Student, :count).by(0)
      end

      it 'returns http unprocessable entity' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:student) { create(:student) }

    context 'with valid parameters' do
      let(:new_attributes) do
        {
          student: {
            name: 'Jane Doe',
            age: 21
          }
        }
      end

      before { patch :update, params: { id: student.id }.merge(new_attributes) }

      it 'updates the student' do
        student.reload
        expect(student.name).to eq('Jane Doe')
        expect(student.age).to eq(21)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          student: {
            name: '',
            age: nil
          }
        }
      end

      before { patch :update, params: { id: student.id }.merge(invalid_attributes) }

      it 'returns http unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:student) { create(:student) }

    context 'when student exists' do
      it 'deletes the student' do
        expect {
          delete :destroy, params: { id: student.id }
        }.to change(Student, :count).by(-1)
      end

      it 'returns http no content' do
        delete :destroy, params: { id: student.id }
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when student does not exist' do
      it 'returns http not found' do
        delete :destroy, params: { id: 'non-existent' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end 