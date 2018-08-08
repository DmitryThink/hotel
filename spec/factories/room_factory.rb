FactoryBot.define do
  factory :room do
    trait :standart do
      number 6
      number_of_people 3
      type_of_room 'standart'
    end
    trait :luxe do
      number 8
      number_of_people 4
      type_of_room 'luxe'
    end
  end
end