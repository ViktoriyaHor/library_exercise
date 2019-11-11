class Book
  include Mongoid::Document
  field :name, type: String
  mount_uploader :image, CoverUploader
  field :description, type: String
  field :status, type: Mongoid::Boolean
  embedded_in :author
end
