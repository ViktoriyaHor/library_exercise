class StaticPagesController < ApplicationController
  def index
    @title = 'Welcome'
    @comments =  Comment.find_by_book(params[:id]).count
  end
end
