# frozen_string_literal: true

class CommentsController < ApplicationController

  def create

    @book = Author.all.map { |a| a.books.find(params[:book_id]) }.compact.first
    if current_user
      @comment = @book.comments.new(comment_params.merge({ user_id: current_user.id }))
      respond_to do |format|
        if @comment.save
          format.js { flash.now[:notice] = 'Comment was successfully created.' }
        else
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to book_path(@book), notice: 'You need to sign in or sign up before continuing.' }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:rating, :body)
  end

end
