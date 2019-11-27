class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :body, type: String
  validates :body, presence: true

  belongs_to :user
  belongs_to :book

  default_scope { order(created_at: :desc) }

  def self.find_by_book(id)
    where(book_id: id)
  end
end
