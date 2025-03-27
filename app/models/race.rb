# == Schema Information
#
# Table name: races
#
#  id         :integer          primary key
#  status     :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Race < ApplicationRecord
  has_many :race_students
  has_many :students, through: :race_students

  accepts_nested_attributes_for :race_students

  enum :status, { ready: 0, completed: 1 }

  validates :status, presence: true
  validates :name, presence: true
end 