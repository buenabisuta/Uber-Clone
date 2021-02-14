FactoryBot.define do
  factory :food1, class: Food do
    id { 1 }
    restaurant_id { 1 }
    name { 'フード0' }
    price { 100 }
    description { 'フード0の商品紹介です' }
  end

  factory :food2, class: Food do
    id { 2 }
    restaurant_id { 1 }
    name { 'フード1' }
    price { 101 }
    description { 'フード1の商品紹介です' }
  end

  factory :food3, class: Food do
    id { 3 }
    restaurant_id { 2 }
    name { 'フード2' }
    price { 102 }
    description { 'フード2の商品紹介です' }
  end
end
