FactoryGirl.define do
  factory :chart do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }

    trait :with_slices do
      after(:create) do |chart|
        create_list(:slice, 5, chart: chart)
      end
    end
    
  end
  
end
