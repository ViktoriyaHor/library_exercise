# frozen_string_literal: true

class History

  include Mongoid::Document
  include Mongoid::Timestamps::Created
  field :return_at, type: Time

  belongs_to :user
  belongs_to :book

  default_scope { order(created_at: :desc) }

  def self.find_by_book(id)
    where(book_id: id)
  end

  def self.find_by_user(id)
    where(user_id: id)
  end
end
