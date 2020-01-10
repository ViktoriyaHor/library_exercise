# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def index
    @comments = Comment.collection.aggregate([
    { '$group' => {
        _id: '$book_id',
        rating: {'$sum' => '$rating'}
    }},
    { '$sort' => {rating: -1} },
    { '$limit' => 5 }
])
  end
end
