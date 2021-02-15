module Api
  module V1
    class OrdersController < ApplicationController
      def create
        pasted_line_foods = LineFood.where(id: params[:line_food_ids])

        order = Order.new(
          restaurant_id: pasted_line_foods.first.restaurant_id,
          total_price: total_price(pasted_line_foods),
        )

        # Orderテーブルにデータを作成
        if order.save_with_update_line_foods!(pasted_line_foods)
          render json: {},status: :no_content
        else
          render json: {},status: :internal_server_error
        end
      end

      private

      def total_price(pasted_line_foods)
        pasted_line_foods.sum { | line_food | line_food.total_amount } + pasted_line_foods.first.restaurant.fee
      end

    end
  end
end
