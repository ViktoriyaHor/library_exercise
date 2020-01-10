# frozen_string_literal: true

FactoryBot.define do

  factory :author do
    fullname { Faker::Book.author }

    factory :author_with_books do
      after(:create) do |author|
        create :book, author: author
      end
    end
  end
end
