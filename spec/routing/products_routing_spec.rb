require "rails_helper"

RSpec.describe ProductsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/products").to route_to("products#index")
    end

    it "routes to #update via PUT" do
      expect(put: "/products/MUG").to route_to("products#update", id: "MUG")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/products/MUG").to route_to("products#update", id: "MUG")
    end
  end
end
