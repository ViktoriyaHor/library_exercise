class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy, :take, :return]
  before_action :find_authors_all, only: [:new, :create, :edit]

  # GET /books
  # GET /books.json
  def index
    @books_array = Author.all.map(&:books).flatten
    @books = Kaminari.paginate_array(@books_array).page(params[:page]).per(3)
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @histories = History.find_by_book(params[:id])
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @author = Author.find_by_fullname(params[:book][:author])
    @book = @author.books.new(book_params)
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    @author = Author.find_by_fullname(params[:book][:author])
    if @author.books.find(params[:id]).nil?
      @book.destroy
      @book = @author.books.new(book_params)
    else
      @book = @author.books.find(params[:id])
      @book.update(book_params) && @book.image.cache!
    end
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def take
    if current_user
      @book.update_attribute(:status, true)
      @history = @book.histories.create(user_id: current_user.id)
      respond_to do |format|
        format.html { redirect_to @book, notice: 'Book was successfully took.' }
        format.json { render json: @history }
        format.js { flash.now[:notice] = 'Book was successfully took.' }
      end
    else
      respond_to do |format|
        format.html { redirect_to @book, notice: 'You need to sign in or sign up before continuing.' }
        format.json { head :no_content }
        format.js { flash.now[:notice] = 'You need to sign in or sign up before continuing.'}
      end
    end

  end

  def return
    @history = @book.histories.find_by_user(current_user.id).where(return_at: nil).first
    @history.update_attributes(return_at: Time.now)
    @book.update_attribute(:status, false)
    respond_to do |format|
      format.html { redirect_to @book, notice: 'Book was successfully return.' }
      format.json { head :no_content }
      format.js { flash.now[:notice] = 'Book was successfully return.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Author.all.map{|a| a.books.find(params[:id])}.compact.first
    end

    def find_authors_all
      @authors = Author.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:name, :image, :description, :status)
    end
end
