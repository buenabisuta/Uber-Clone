class CreateRestaurants < ActiveRecord::Migration[6.0]
  def change
    create_table :restaurants do |t|
      # レストラン名
      t.string :name, null: false
      # 配達手数料
      t.integer :fee, null: false, default: 0
      # 配送手数料
      t.integer :time_required, null: false

      t.timestamps
    end
  end
end
