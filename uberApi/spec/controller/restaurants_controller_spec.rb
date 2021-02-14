require 'rails_helper'
require "json"

RSpec.describe Api::V1::RestaurantsController, type: :controller do
  
  describe "index確認" do
    before do
      FactoryBot.create(:restaurant1)
      FactoryBot.create(:restaurant2)
    end

    it "200レスポンス" do
      get :index
      expect(response).to have_http_status '200'  
    end

    it "resposeデータの確認" do
      get :index
      results = JSON.parse(response.body)['restaurants']
      defaultFee = 100
      defaultTime = 10
      defaultName = 'レストラン'

      results.each_with_index do | result , i |
        index = i + 1
        expect(result['id']).to eq index
        expect(result['name']).to eq defaultName + index.to_s
        expect(result['fee']).to eq defaultFee * index
        expect(result['time_required']).to eq defaultTime * index
      end
      expect(results.count).to eq 2
    end
  end
  
end
