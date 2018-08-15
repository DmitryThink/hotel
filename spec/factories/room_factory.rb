FactoryBot.define do
  factory :room do
    trait :standart do
      number 3
      number_of_people 3
      type_of_room 'standart'
    end
    trait :luxe do
      number 3
      number_of_people 4
      type_of_room 'luxe'
    end
  end
end