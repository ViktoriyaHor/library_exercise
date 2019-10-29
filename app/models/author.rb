class Author
  include Mongoid::Document
  field :fullname, type: String
  has_many :books
end
