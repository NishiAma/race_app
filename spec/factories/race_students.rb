FactoryBot.define do
  factory :race_student do
    association :race
    association :student
    sequence(:lane) { |n| n }
    place { nil }

    trait :with_place do
      sequence(:place) { |n| n }
    end
  end
end 