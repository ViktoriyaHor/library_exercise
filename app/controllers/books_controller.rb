# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy take return]
  before_action :find_authors_all, only: %i[new create edit]
  before_action :find_author, only: %i[create update]

  # GET /books
  def index
    @books_array = Author.all.map(&:books).flatten
    @books = Kaminari.paginate_array(@books_array).page(params[:page]).per(3)
  end

  # GET /books/1
  def show
    @history = @book.histories.find_by_user(current_user.id)
                   .where(return_at: nil).first if current_user
    @histories = History.find_by_book(params[:id])
    @comments = Comment.find_by_book(params[:id])
    @ratings_count = Comment.find_by_book(params[:id]).not_in(rating: 0).count
    sum_rating = Comment.find_by_book(params[:id]).sum(:rating)
    @average_rating = (sum_rating.to_f / @ratings_count).round if @ratings_count.positive?
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit;  end

  # POST /books
  def create
    @book = @author.books.new(book_params.except(:author))
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /books/1
  def update
    if @author.books.find(params[:id]).nil?
      @book.destroy
      @book = @author.books.new(book_params.except(:author))
    else
      @book = @author.books.find(params[:id])
      @book.update(book_params.except(:author)) && @book.image.cache!
    end
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy
    History.find_by_book(@book.id).destroy
    Comment.find_by_book(@book.id).destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
    end
  end

  def take
    if current_user
      @book.update_attribute(:status, true)
      @history = @book.histories.create(user_id: current_user.id)
      respond_to do |format|
        format.js { flash.now[:notice] = 'Book was successfully took.' }
      end
    else
      respond_to do |format|
        format.html { redirect_to book_path(@book), alert: 'You need to sign in or sign up before continuing.'}
      end
    end
  end

  def return
    if current_user
      @history = @book.histories.find_by_user(current_user.id)
                     .where(return_at: nil).first
      @history.update_attributes(return_at: Time.now)
      @book.update_attribute(:status, false)
      respond_to do |format|
        format.js { flash.now[:notice] = 'Book was successfully return.' }
        format.html { redirect_to @book, notice: 'Book was successfully return.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to book_path(@book), alert: 'You need to sign in or sign up before continuing.'}
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Author.all.map { |a| a.books.find(params[:id]) }.compact.first
  end

  def find_authors_all
    @authors = Author.all
  end

  def find_author
    @author = Author.find_by_fullname(book_params[:author])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.require(:book).permit( :name, :image, :description, :status, :author )
  end
end
