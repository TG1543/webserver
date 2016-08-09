FactoryGirl.define do
  factory :project do
    name { FFaker::Product.product_name }
    description { FFaker::Product.describe }
  end
end
