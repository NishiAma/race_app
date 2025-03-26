# == Schema Information
#
# Table name: race_students
#
#  id         :integer          primary key
#  race_id    :integer          not null, foreign key
#  student_id :integer          not null, foreign key
#  lane       :integer          not null
#  place      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes:
#  index_race_students_on_race_id_and_lane         (race_id,lane) UNIQUE
#  index_race_students_on_race_id_and_student_id   (race_id,student_id) UNIQUE
#  index_race_students_on_race_id_and_place        (race_id,place)
#
class RaceStudent < ApplicationRecord
  belongs_to :race
  belongs_to :student

  validates :lane, presence: true, 
                  numericality: { only_integer: true, greater_than: 0 }
  validates :place, numericality: { only_integer: true, greater_than: 0 }, 
                   allow_nil: true
  
  # Ensure unique lane per race
  validates :lane, uniqueness: { scope: :race_id }
  
  # Ensure unique student per race
  validates :student_id, uniqueness: { scope: :race_id }
  validates :place, uniqueness: { scope: :race_id }, if: :place?
end 