require 'rails_helper'

RSpec.describe Race, type: :model do
  describe 'associations' do
    it { should have_many(:race_students) }
    it { should have_many(:students).through(:race_students) }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(ready: 0, completed: 1) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:race)).to be_valid
    end

    it 'has a valid factory with completed status' do
      expect(build(:race, :completed)).to be_valid
    end
  end
end 