# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    name { Faker::Book.title }
    remote_image_url { Faker::Avatar.image(size: '450x450') }
    description { Faker::Lorem.sentence(word_count: 20) }
    status { false }
    author

    factory :book_with_histories do
      after(:create) do |book|
        create_list :history, 3, book: book
      end
    end

    factory :book_with_comments do
      after(:create) do |book|
        create_list :comment, 3, book: book
      end
    end

    factory :book_with_history_and_comment do
      after(:create) do |book|
        create :history, book: book
        create :comment_with_rating5, book: book
      end
    end

  end
end
