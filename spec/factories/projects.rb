FactoryGirl.define do
  factory :project do
    name { FFaker::Product.product_name }
    description { "description #{name}" }
    user
    state
  end
end
