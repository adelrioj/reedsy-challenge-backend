class CreatePercentageDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :percentage_discounts do |t|
      t.string :product_code
      t.integer :quantity_threshold
      t.decimal :percentage, precision: 5, scale: 2

      t.timestamps
    end
  end
end
