FactoryBot.define do
  factory :project do
    title { "MyString" }
    description { "MyText" }
    status { 1 }
    user { nil }
  end
end
