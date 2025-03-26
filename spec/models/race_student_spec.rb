require 'rails_helper'

RSpec.describe RaceStudent, type: :model do
  describe 'associations' do
    it { should belong_to(:race) }
    it { should belong_to(:student) }
  end

  describe 'validations' do
    subject { create(:race_student) }

    it { should validate_presence_of(:lane) }
    it { should validate_numericality_of(:lane).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:place).only_integer.is_greater_than(0).allow_nil }
    
    it { should validate_uniqueness_of(:lane).scoped_to(:race_id) }
    it { should validate_uniqueness_of(:student_id).scoped_to(:race_id) }
    
    context 'when place is present' do
      subject { create(:race_student, :with_place) }
      it { should validate_uniqueness_of(:place).scoped_to(:race_id) }
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:race_student)).to be_valid
    end

    it 'has a valid factory with place' do
      expect(build(:race_student, :with_place)).to be_valid
    end
  end
end 