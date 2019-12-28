class Author
  include Mongoid::Document
  field :fullname, type: String
  validates :fullname, :presence => true
  embeds_many :books, cascade_callbacks: true

  def self.find_by_fullname(fullname)
    where(fullname: fullname).first
  end
end
