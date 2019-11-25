# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

5.times do
  author = Author.create(fullname: Faker::Book.author)
  5.times do
    author.books.create(name: Faker::Book.title,
                        remote_image_url: Faker::Avatar.image( size: "450x450" ),
                        description: Faker::Lorem.sentence(word_count: 20),
                        status: false )
  end
end

user = User.create(email: "user@name.com", password: 'password', password_confirmation: 'password')
user.confirm



