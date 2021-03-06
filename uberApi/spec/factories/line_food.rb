FactoryBot.define do
  factory :line_food1, class: LineFood do
    id { 1 }
    restaurant_id { 1 }
    food_id { 1 }
    count { 1 }
    active { true }
  end

  factory :line_food2, class: LineFood do
    id { 2 }
    restaurant_id { 1 }
    food_id { 2 }
    count { 1 }
    active { true }
  end

  factory :line_food3, class: LineFood do
    id { 3 }
    restaurant_id { 1 }
    count { 1 }
    active { true }
  end

  factory :line_food4, class: LineFood do
    id { 2 }
    restaurant_id { 1 }
    food_id { 2 }
    count { 2 }
    active { true }
  end
end
