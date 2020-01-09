# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  describe 'routes' do
    it { expect(get: '/books').to route_to controller: 'books', action: 'index' }
    it { expect(post: '/books').to route_to controller: 'books', action: 'create' }
    it { expect(get: '/books/new').to route_to controller: 'books', action: 'new' }
    it { expect(get: '/books/1/edit').to route_to controller: 'books', action: 'edit', id: '1' }
    it { expect(get: '/books/1').to route_to controller: 'books', action: 'show', id: '1' }
    it { expect(patch: '/books/1').to route_to controller: 'books', action: 'update', id: '1' }
    it { expect(put: '/books/1').to route_to controller: 'books', action: 'update', id: '1' }
    it { expect(delete: '/books/1').to route_to controller: 'books', action: 'destroy', id: '1' }
    it { expect(patch: '/book/1/take').to route_to controller: 'books', action: 'take', id: '1' }
    it { expect(patch: '/book/1/return').to route_to controller: 'books', action: 'return', id: '1' }
  end

  describe 'actions' do
    let!(:book) { create :book_with_history_and_comment }

    context '#index' do
      subject! { get :index }

      it { is_expected.to have_http_status 200 }
      it { is_expected.to render_template :index }
      it 'assigns @books_array, @books is an instance of Array' do
        %i[@books_array @books].each do |variable|
          expect(controller.instance_variable_get(variable)).to be_a Array
        end
        expect(assigns(:books)).to eq [book]
      end
    end

    context '#show' do
      subject! { get :show, params: { id: book.id } }

      it { is_expected.to have_http_status 200 }
      it { is_expected.to render_template :show }
      it 'receive method :set_book and return book ' do
        expect(controller).to receive(:set_book)
        get :show, params: { id: book.id }
      end
      it 'requires the id parameter' do
        expect { get :show }.to raise_error ActionController::UrlGenerationError
      end
      it 'assigns @histories' do
        expect(assigns(:histories)).to eq book.histories
      end
      it 'assigns @comments' do
        expect(assigns(:comments)).to eq book.comments
      end
      it 'assigns @ratings_count' do
        expect(assigns(:ratings_count)).to eq book.comments.count
      end
      it 'assigns @average_rating' do
        expect(assigns(:average_rating)).to eq 5
      end
    end

    context '#new' do
      subject! { get :new }
      let(:book) { double(Book) }

      it { is_expected.to have_http_status 200 }
      it { is_expected.to render_template :new }
      it 'assigns @book' do
        expect(assigns(:book)).to be_a_new Book
      end
    end

    context '#edit' do
      #let(:book) { create(:book) }
      subject! { get :edit, params: { id: book.id } }

      it { is_expected.to have_http_status 200 }
      it { is_expected.to render_template :edit }
      it 'assigns @book' do
        expect(assigns(:book)).to eq book
      end
      it 'assigns @authors' do
        expect(assigns(:authors)).to eq Author.all
      end
    end

    context '#create with valid attributes' do
      let(:author) { build(:author) }
      let(:book) { build(:book, author: author) }
      let(:book_params) { attributes_for(:book) }

      it 'save a book' do
        expect(book.save!).to be true
      end

      before do
        allow(Author).to receive(:find_by_fullname).and_return(author)
        post :create, params: { book: book_params }
      end

      context 'after create' do
        it 'redirects to the new book' do
          expect(response).to redirect_to author.books.last
        end
        it 'sends notice flash' do
          expect(flash[:notice]).to eq 'Book was successfully created.'
        end
        it 'returns a successful response to POST' do
          expect(response).to have_http_status(302)
        end
      end
    end

    context '#create with invalid attributes' do
      let(:author) { build(:author) }
      let(:book) { build(:book, author: author, name: nil) }
      let(:invalid_book_params) { attributes_for(:book).except(:name) }

      it 'don\'t save a book' do
        expect(book).to_not be_valid
      end

      before do
        allow(Author).to receive(:find_by_fullname).and_return(author)
        post :create, params: { book: invalid_book_params }
      end

      context 'after create' do
        it 'redirects to the new book' do
          expect(response).to render_template :new
        end
        it 'sends notice flash' do
          expect(flash[:notice]).to eq nil
        end
        it 'returns a successful response to POST' do
          expect(response).to have_http_status 200
        end
        it 'don\'t create a new book' do
          expect(author.books.count).to eq 0
        end
      end
    end

    context '#update with valid attributes' do
      let(:author) { create(:author) }
      let(:book) { create(:book, author: author) }
      let(:book_params) { attributes_for(:book) }

      it 'update a book' do
        expect(book.update!(book_params)).to be true
      end

      before do
        allow(Author).to receive(:find_by_fullname).and_return(author)
        put :update, params: { id: book.id, book: book_params }
      end

      context 'after update' do
        it 'redirects to the book' do
          expect(response).to redirect_to book_path(book)
        end
        it 'sends notice flash' do
          expect(flash[:notice]).to eq 'Book was successfully updated.'
        end
        it 'returns a successful response to POST' do
          expect(response).to have_http_status 302
        end
      end
    end

    context '#update with invalid attributes' do
      let(:author) { create(:author) }
      let(:book) { create(:book, author: author) }

      it 'don\'t save a book' do
        expect(book.update(name: nil)).to eq false
      end

      before do
        allow(Author).to receive(:find_by_fullname).and_return(author)
        put :update, params: { id: book.id, book: { name: nil } }
      end

      context 'after update' do
        it 'redirects to the edit book' do
          expect(response).to render_template(:edit)
        end
        it 'sends notice flash' do
          expect(flash[:notice]).to eq nil
        end
        it 'returns a status' do
          expect(response).to have_http_status(200)
        end
      end
    end

    context '#destroy' do
      let(:book) { create(:book_with_history_and_comment) }
      before do
        delete :destroy, params: { id: book.id }
      end
      it 'has a 302 status code' do
        expect(response).to have_http_status 302
      end
      it 'should redirect to profile after remove category' do
        expect(response).to redirect_to books_url
      end
      it 'sends notice flash' do
        expect(flash[:notice]).to eq 'Book was successfully destroyed.'
      end
      it 'receive method :set_book and return book ' do
        expect(controller).to receive(:set_book)
        delete :destroy, params: { id: book.id }
      end
      it 'delete book' do
        expect(Book.count).to eq 0
      end
      it 'cascade delete histories' do
        expect(History.count).to eq 0
      end
      it 'cascade delete comments' do
        expect(Comment.count).to eq 0
      end
    end
    context '#take when user sign in' do
      let(:user) { create(:user) }
      let(:history) { create(:history, user: user, book: book, return_at: nil) }
      before do
        sign_in user
        patch :take, params: { id: book.id }, format: :js
      end
      it 'should have a current_user' do
        expect(subject.current_user).to_not eq nil
      end
      it 'has a 200 status code' do
        expect(response).to have_http_status 200
      end
      it 'should redirect to render_template' do
        expect(response).to render_template 'books/take'
      end
      it 'sends notice flash' do
        expect(flash[:notice]).to eq "Book was successfully took."
      end
      it 'receive method :set_book and return book ' do
        expect(controller).to receive(:set_book).and_return book
        patch :take, params: { id: book.id }
      end
      it 'requires the id parameter' do
        expect { patch :take }.to raise_error ActionController::UrlGenerationError
      end
      it 'assigns @history' do
        expect(assigns(:history)).to eq (user.histories & book.histories).first
      end
      it 'history must be saved' do
        expect(book.histories.last.save!).to be true
      end
    end
    context '#take when user sign out' do
      before do
        patch :take, params: { id: book.id }
      end
      it 'has a 200 status code' do
        expect(response).to have_http_status 302
      end
      it 'should redirect to book' do
        expect(response).to redirect_to book_path book
      end
      it 'sends notice flash' do
        expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
      end
      it 'receive method :set_book and return book ' do
        expect(controller).to receive(:set_book).and_return book
        patch :return, params: { id: book.id }
      end
    end
    context '#return when user sign in' do
      let(:user) { create(:user) }
      let!(:history) { create(:history, user: user, book: book, return_at: nil) }
      before do
        sign_in user
        patch :return, params: { id: book.id }, format: :js
      end
      it 'should have a current_user' do
        expect(subject.current_user).to eq user
      end
      it 'has a 200 status code' do
        expect(response).to have_http_status 200
      end
      it 'should render_template' do
        expect(response).to render_template 'books/return'
      end
      it 'sends notice flash' do
        expect(flash[:notice]).to eq "Book was successfully return."
      end
      it 'assigns @history' do
        expect(assigns(:history)).to eq history
      end
    end
    context '#return when user sign out' do
      before do
        patch :return, params: { id: book.id }
      end
      it 'has a 200 status code' do
        expect(response).to have_http_status 302
      end
      it 'should redirect to book' do
        expect(response).to redirect_to book_path(book)
      end
      it 'sends notice flash' do
        expect(flash[:alert]).to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end
  describe 'strong params' do
    let(:author) { build(:author) }
    let(:book) { create(:book, author: author) }
    let(:book_params) { attributes_for(:book) }
    it do
      permit(:name, :image, :description, :status, :author)
          .for(:create, params: book_params)
    end
  end
end
