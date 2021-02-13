class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :restaurant, null: false, foreign_key: true
      # 合計金額
      t.integer :total_price, null: false, default: 0

      t.timestamps
    end
  end
end
