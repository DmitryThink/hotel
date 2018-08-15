FactoryBot.define do
  factory :month do
    day_1 3
    day_2 3
    day_3 3
    day_4 3
    day_5 3
    day_6 3
    day_7 3
    day_8 3
    day_9 3
    day_10 3
    day_11 3
    day_12 3
    day_13 3
    day_14 3
    day_15 3
    day_16 3
    day_17 3
    day_18 3
    day_19 3
    day_20 3
    day_21 3
    day_22 3
    day_23 3
    day_24 3
    day_25 3
    day_26 3
    day_27 3
    day_28 3
    day_29 3
    day_30 3

    trait :june do
      number 6
      price 800
      name 'June'
      max_days 30
    end

    trait :july do
      number 7
      price 900
      name 'July'
      max_days 31
      day_31 3
    end

    trait :may do
      number 5
      price 600
      name 'May'
      max_days 31
      day_31 3
    end
  end
end