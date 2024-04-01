# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Product.find_or_create_by!(code: "MUG") do |product|
  product.name = "Reedsy Mug"
  product.price = 6.0
end

Product.find_or_create_by!(code: "TSHIRT") do |product|
  product.name = "Reedsy T-shirt"
  product.price = 15.0
end

Product.find_or_create_by!(code: "HOODIE") do |product|
  product.name = "Reedsy Hoodie"
  product.price = 20.0
end

PercentageDiscount.find_or_create_by!(product_code: "TSHIRT", quantity_threshold: 3, percentage: 30)

# Up to 30% discount on MUGs when 150 or more
(1..15).each do |index|
  PercentageDiscount.find_or_create_by!(product_code: "MUG", quantity_threshold: index * 10, percentage: index * 2)
end