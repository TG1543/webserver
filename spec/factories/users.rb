FactoryGirl.define do
  factory :user do
    name { "Nombre"}
    active { "true"}
    email { FFaker::Internet.email }
    password "12345678"
    password_confirmation "12345678"
    rol
  end
end
