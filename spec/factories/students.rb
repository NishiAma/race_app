FactoryBot.define do
  factory :student do
    sequence(:name) { |n| "Student #{n}" }
    age { rand(18..25) }
  end
end 