# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { Faker::Quotes::Shakespeare.hamlet_quote }
    user
    book

    trait :with_rating do
      rating { Faker::Number.between(from: 0, to: 5) }
    end

    trait :with_rating5 do
      rating { 5 }
    end

    factory :comment_with_rating,   traits: [:with_rating]

    factory :comment_with_rating5,   traits: [:with_rating5]

  end
end
