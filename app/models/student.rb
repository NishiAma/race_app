# == Schema Information
#
# Table name: students
#
#  id         :integer          primary key
#  name       :string           not null
#  age        :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Student < ApplicationRecord
  has_many :race_students
  has_many :races, through: :race_students

  validates :name, presence: true
  validates :age, presence: true, 
                 numericality: { only_integer: true, greater_than: 0 }
end 