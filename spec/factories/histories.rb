FactoryBot.define do
  factory :history do
    return_at { Faker::Time.between(from: DateTime.now, to: DateTime.now + 1) }
    user
    book
  end
end
