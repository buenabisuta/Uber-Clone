class CreateFoods < ActiveRecord::Migration[6.0]
  def change
    create_table :foods do |t|
      t.references :restaurant, null: false, foreign_key: true
      # 名前
      t.string :name, null:false
      # 値段
      t.integer :price, null: false
      # 商品詳細
      t.text :description, null: false

      t.timestamps
    end
  end
end
