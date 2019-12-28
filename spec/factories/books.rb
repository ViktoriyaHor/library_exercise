FactoryBot.define do
  factory :book do
    name { Faker::Book.title }
    image { Rack::Test::UploadedFile.new(Faker::Avatar.image( size: "450x450" )) }
    description { Faker::Lorem.sentence(word_count: 20) }
    status { false }
    author
  end
end
