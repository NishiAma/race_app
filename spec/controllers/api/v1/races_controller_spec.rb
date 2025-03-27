require 'rails_helper'

RSpec.describe Api::V1::RacesController, type: :controller do
  describe 'GET #index' do
    let!(:old_race) { create(:race, updated_at: 2.days.ago) }
    let!(:new_race) { create(:race, updated_at: 1.day.ago) }
    let!(:newest_race) { create(:race, updated_at: 1.hour.ago) }

    before do
      get :index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns all races' do
      expect(JSON.parse(response.body).size).to eq(3)
    end

    it 'returns races sorted by updated_at in descending order' do
      json_response = JSON.parse(response.body)
      expect(json_response.map { |r| r['id'] }).to eq([newest_race.id, new_race.id, old_race.id])
    end

    it 'returns races with correct attributes' do
      json_response = JSON.parse(response.body)
      expect(json_response.first.keys).to match_array(%w[id name status created_at updated_at])
    end
  end

  describe 'POST #create' do
    let!(:students) { create_list(:student, 3) }
    
    let(:valid_attributes) do
      {
        race: {
          name: 'New Race',
          status: 'ready',
          race_students: [
            { student_id: students[0].id, lane: 1 },
            { student_id: students[1].id, lane: 2 },
            { student_id: students[2].id, lane: 3 }
          ]
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new race' do
        expect {
          post :create, params: valid_attributes
        }.to change(Race, :count).by(1)
      end

      it 'returns the created race' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq('New Race')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          race: {
            status: 'ready',
            race_students: [
              { student_id: students[0].id, lane: 1 },
              { student_id: students[1].id, lane: 1 } # Duplicate lane
            ]
          }
        }
      end

      it 'does not create a new race' do
        expect {
          post :create, params: invalid_attributes
        }.to change(Race, :count).by(0)
      end

      it 'returns unprocessable entity status' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:race) { create(:race) }
    let!(:race_student1) { create(:race_student, race: race) }
    let!(:race_student2) { create(:race_student, race: race) }
    let!(:race_student3) { create(:race_student, race: race) }

    let(:valid_attributes) do
      {
        id: race.id,
        race: {
          race_students: [
            { id: race_student1.id, place: 1 },
            { id: race_student2.id, place: 2 },
            { id: race_student3.id, place: 3 }
          ]
        }
      }
    end

    context 'with valid parameters' do
      it 'updates race status to completed' do
        patch :update, params: valid_attributes
        expect(race.reload.completed?).to be true
      end

      it 'updates race_students places' do
        patch :update, params: valid_attributes
        expect(race_student1.reload.place).to eq(1)
        expect(race_student2.reload.place).to eq(2)
        expect(race_student3.reload.place).to eq(3)
      end

      it 'returns success status' do
        patch :update, params: valid_attributes
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          id: race.id,
          race: {
            race_students: [
              { id: race_student1.id, place: 1 },
              { id: race_student2.id, place: 1 } # Duplicate place
            ]
          }
        }
      end

      it 'does not update race status' do
        patch :update, params: invalid_attributes
        expect(race.reload.ready?).to be true
      end

      it 'returns unprocessable entity status' do
        patch :update, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with non-existent race' do
      it 'returns not found status' do
        patch :update, params: { id: 'non-existent' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end 