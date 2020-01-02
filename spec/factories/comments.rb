FactoryBot.define do
  factory :comment do
    body { Faker::Quotes::Shakespeare.hamlet_quote }
    user
    book
  end
end
