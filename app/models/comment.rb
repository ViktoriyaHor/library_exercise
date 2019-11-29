class Comment
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :body, type: String
  field :rating, type: Integer, default: ->{ '0' }

  validates :body, presence: true
  validates :rating, presence: true, numericality: { less_than_or_equal_to: 5,  only_integer: true }

  belongs_to :user
  belongs_to :book

  default_scope { order(created_at: :desc) }

  def self.find_by_book(id)
    where(book_id: id)
  end
end
