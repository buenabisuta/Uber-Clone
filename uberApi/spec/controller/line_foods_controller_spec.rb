require 'rails_helper'
require "json"

RSpec.describe Api::V1::LineFoodsController, type: :controller do
  
  describe "indexの正常確認" do
    before do
      FactoryBot.create(:restaurant1)
      FactoryBot.create(:food1)
      FactoryBot.create(:food2)
      FactoryBot.create(:line_food1)
      FactoryBot.create(:line_food2)
    end

    it "indexの正常ステータスレスポンス" do
      get :index
      expect(response).to  have_http_status '200'
    end

    it "indexの仮注文レスポンスデータ取得" do
      get :index

      result = JSON.parse(response.body)
      expect(result['line_foods_ids'][0]).to eq 1
      expect(result['line_foods_ids'][1]).to eq 2
      expect(result['restaurant']['id']).to eq 1
      expect(result['restaurant']['name']).to eq 'レストラン1'
      expect(result['restaurant']['fee']).to eq 100 
      expect(result['restaurant']['time_required']).to eq 10
      expect(result['count']).to eq 2
      expect(result['amount']).to eq 201
    end
  end

  describe "indexの仮注文データが存在しない場合の確認" do
    it "indexの仮注文データが存在しない場合のステータスレスポンス" do
      get :index
      expect(response).to  have_http_status '204'
    end

    it "indexのの仮注文データが存在しない場合のレスポンスデータ取得" do
      get :index

      result = JSON.parse(response.body)
      expect(result.size).to eq 0
    end
  end

  describe "create_初回作成確認" do
    before do
      FactoryBot.create(:restaurant1)
      FactoryBot.create(:food1)
      FactoryBot.create(:food2)
    end

    it "createデータの正常ステータスレスポンス" do
      food_id = 1
      count = 2
      
      post :create, params: { food_id: food_id , count: count }
      expect(response).to have_http_status '201' 
    end

    it "createデータでlinefoodsの作成確認" do
      food_id = 1
      count = 2
      
      post :create, params: { food_id: food_id , count: count }
      results = JSON.parse(response.body)['line_food']

      expect(results['food_id']).to eq 1
      expect(results['restaurant_id']).to eq 1
      expect(results['order_id']).to eq nil
      expect(results['count']).to eq 2
      expect(results['active']).to eq true
    end
  end

  describe "create_同じ店舗で2回目の仮注文_同じ商品での確認" do
    before do
      FactoryBot.create(:restaurant1)
      FactoryBot.create(:food1)
      FactoryBot.create(:food2)
      FactoryBot.create(:line_food1)
    end

    it "createデータの正常ステータスレスポンス" do
      food_id = 1
      count = 2
      
      post :create, params: { food_id: food_id , count: count }
      expect(response).to have_http_status '201' 
    end

    it "createデータでlinefoodsの作成確認" do
      food_id = 1
      count = 2
      
      post :create, params: { food_id: food_id , count: count }
      results = JSON.parse(response.body)['line_food']

      food = LineFood.all

      expect(food[0].food_id).to eq 1
      expect(food[0].restaurant_id).to eq 1
      expect(food[0].order_id).to eq nil
      expect(food[0].count).to eq 2
      expect(food[0].active).to eq true
    end
  end

  describe "create_同じ店舗で2回目の仮注文_別商品での確認" do
    before do
      FactoryBot.create(:restaurant1)
      FactoryBot.create(:food1)
      FactoryBot.create(:food2)
      FactoryBot.create(:line_food2)
    end

    it "createデータの正常ステータスレスポンス" do
      food_id = 1
      count = 2
      
      post :create, params: { food_id: food_id , count: count }
      expect(response).to have_http_status '201' 
    end

    it "create_データでlinefoodsの作成確認" do
      food_id = 1
      count = 2
      
      post :create, params: { food_id: food_id , count: count }
      results = JSON.parse(response.body)['line_food']

      food = LineFood.all

      # 最初に作成していた仮注文データ
      expect(food[0].food_id).to eq 2
      expect(food[0].restaurant_id).to eq 1
      expect(food[0].order_id).to eq nil
      expect(food[0].count).to eq 1
      expect(food[0].active).to eq true

      # 追加で作成した仮注文データ
      expect(food[1].food_id).to eq 1
      expect(food[1].restaurant_id).to eq 1
      expect(food[1].order_id).to eq nil
      expect(food[1].count).to eq 2
      expect(food[1].active).to eq true
    end
  end

  describe "create_別の店舗からの仮注文の場合の確認" do
    before do
      FactoryBot.create(:restaurant1)
      FactoryBot.create(:restaurant2)
      FactoryBot.create(:food1)
      FactoryBot.create(:food2)
      FactoryBot.create(:food3)
      FactoryBot.create(:line_food1)
    end

    it "createデータの異常時のステータスレスポンス" do
      food_id = 3
      count = 2
      
      post :create, params: { food_id: food_id , count: count }
      expect(response).to have_http_status '406' 
    end

    it "別店舗から仮注文を行う際のレスポンスデータ確認" do
      food_id = 3
      count = 2
      
      post :create, params: { food_id: food_id , count: count }
      existsRestaurant = JSON.parse(response.body)['existing_restaurant']
      newRestaurant = JSON.parse(response.body)['new_restaurant']

      expect(newRestaurant).to eq 'レストラン2'
      expect(existsRestaurant).to eq 'レストラン1'
    end
  end

end
