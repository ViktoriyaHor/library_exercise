class StaticPagesController < ApplicationController
  def index
    @title = 'Popular books'
    @comments = Comment.collection.aggregate([
    {"$group" => {
        "_id" => "$book_id",
        "rating" => {"$sum" => "$rating"}
    }},
    {"$sort" => { "rating" => -1}}
])

  end
end
