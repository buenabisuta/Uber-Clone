require 'rails_helper'
require "json"

RSpec.describe Api::V1::OrdersController, type: :controller do
  
  describe "create確認" do
    before do
      FactoryBot.create(:restaurant1)
      FactoryBot.create(:food1)
      FactoryBot.create(:food2)
      FactoryBot.create(:line_food1)
      FactoryBot.create(:line_food4)
    end

    it "204レスポンス" do
      line_food_ids = [1,2]

      post :create, params: { line_food_ids: line_food_ids }
      expect(response).to have_http_status '204'  
    end

    it "resposeデータの確認" do
      line_food_ids = [1,2]

      post :create, params: { line_food_ids: line_food_ids }

      line_foods = LineFood.all
      orders = Order.all

      expect(line_foods[0].restaurant_id).to eq 1
      expect(line_foods[0].active).to eq false
      expect(line_foods[1].restaurant_id).to eq 1
      expect(line_foods[1].active).to eq false

      expect(orders[0].restaurant_id).to eq 1
      # 仮注文合計値:302,店舗手数料:100
      expect(orders[0].total_price).to eq 402
    end
  end
  
end
