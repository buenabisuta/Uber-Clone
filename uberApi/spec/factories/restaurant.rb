FactoryBot.define do
  factory :restaurant1, class: Restaurant do
    id { 1 }
    name { 'レストラン1' }
    fee { 100 }
    time_required { 10 }
    created_at { '' }
    updated_at { '' }
  end

  factory :restaurant2, class: Restaurant do
    id { 2 }
    name { 'レストラン2' }
    fee { 200 }
    time_required { 20 }
    created_at { '' }
    updated_at { '' }
  end

end
