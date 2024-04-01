class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products, id: false do |t|
      t.string :code, primary_key: true
      t.string :name
      t.decimal :price, null: false, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
