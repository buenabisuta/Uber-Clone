module Api
  module V1
    class RestaurantsController < ApplicationController
      def index
        restaurant = Restaurant.all

        render json: {
          restaurants: restaurant 
        }, status: :ok
      end
    end
  end
end
