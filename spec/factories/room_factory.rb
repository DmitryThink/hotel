FactoryBot.define do
  factory :room do
    trait :standart do
      number 3
      number_of_people 3
      name 'standart'
    end
    trait :room do
      number 3
      number_of_people 4
      name 'room'
    end
  end
end