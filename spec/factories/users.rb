# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    role { 'member' } # Default role

    # Define a trait for admin
    trait :admin do
      role { 'admin' }
    end
  end
end
