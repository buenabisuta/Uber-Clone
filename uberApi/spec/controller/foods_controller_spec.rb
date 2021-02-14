require 'rails_helper'
require "json"

RSpec.describe Api::V1::FoodsController, type: :controller do
  
  describe "index確認" do
    before do
      FactoryBot.create(:restaurant1)
      FactoryBot.create(:restaurant2)
      FactoryBot.create(:food1)
      FactoryBot.create(:food2)
      FactoryBot.create(:food3)
    end

    it "200レスポンス" do
      restaurant_id = 1

      get :index, params: { restaurant_id: restaurant_id }
      expect(response).to have_http_status '200'  
    end

    it "resposeデータの確認" do
      restaurant_id = 1
      
      get :index, params: { restaurant_id: restaurant_id }
      results = JSON.parse(response.body)['foods']

      defaultprice = 100
      defaultDescription = 'の商品紹介です'
      defaultName = 'フード'

      results.each_with_index do | result , i |
        expect(result['id']).to eq i + 1
        expect(result['name']).to eq defaultName + i.to_s
        expect(result['description']).to eq defaultName + i.to_s + defaultDescription
        expect(result['price']).to eq defaultprice + i
        expect(result['restaurant_id']).to eq restaurant_id
      end
      expect(results.count).to eq 2
    end
  end
  
end
