require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'associations' do
    it { should have_many(:race_students) }
    it { should have_many(:races).through(:race_students) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age).only_integer.is_greater_than(0) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:student)).to be_valid
    end
  end
end 