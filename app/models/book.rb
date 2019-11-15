class Book
  include Mongoid::Document
  field :name, type: String
  mount_uploader :image, CoverUploader
  field :description, type: String
  field :status, type: Mongoid::Boolean
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true, uniqueness: true
  embedded_in :author
  has_many :histories

  def users
    User.in(id: histories.pluck(:user_id))
  end
end
