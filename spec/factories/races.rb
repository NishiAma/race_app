FactoryBot.define do
  factory :race do
    sequence(:name) { |n| "Race #{n}" }
    status { :ready }

    trait :completed do
      status { :completed }
    end
  end
end 