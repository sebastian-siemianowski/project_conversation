FactoryBot.define do
  factory :comment do
    content { "MyText" }
    user { nil }
    project { nil }
  end
end
