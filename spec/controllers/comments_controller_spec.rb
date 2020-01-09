# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe 'route' do
    it { expect(post: '/books/1/comments').to route_to controller: 'comments',
                                                       action: 'create',
                                                       'book_id': '1' }
  end
  describe 'action' do

    context '#create with valid attributes when user sign_in' do
      let(:user) { create(:user) }
      let(:book) { create(:book) }
      let(:comment) { build(:comment, book: book) }
      let(:comment_params) { attributes_for(:comment) }

      it 'save a book' do
        expect(comment.save!).to be true
      end

      before do
        sign_in user
        post :create, format: :js, params: { book_id: book.id, comment: comment_params }
      end
      context 'after create' do
        it 'should have a current_user' do
          expect(subject.current_user).to_not eq nil
        end
        it 'redirects to the new comment' do
          expect(response).to render_template 'comments/create'
        end
        it 'sends notice flash' do
          expect(flash[:notice]).to eq 'Comment was successfully created.'
        end
        it 'returns a successful response to POST' do
          expect(response).to have_http_status(200)
        end
        it 'assigns @book' do
          expect(assigns(:book)).to eq book
        end
        it 'assigns @comment' do
          expect(assigns(:comment)).to eq book.comments.first
        end
      end
    end
    context '#create with with user sign out' do
      let(:book) { create(:book) }
      let(:comment) { build(:comment, book: book) }

      before do
        post :create, params: { book_id: book.id }
      end

      context 'after create' do
        it 'should have a current_user' do
          expect(subject.current_user).to eq nil
        end
        it 'redirects to the new comment' do
          expect(response).to redirect_to book_path(book)
        end
        it 'sends notice flash' do
          expect(flash[:notice]).to eq 'You need to sign in or sign up before continuing.'
        end
        it 'returns a successful response to POST' do
          expect(response).to have_http_status 302
        end
        it 'don\'t create a new book' do
          expect(Comment.count).to eq 0
        end
      end
    end
  end
  describe 'strong params' do

    let(:comment_params) { attributes_for(:comment) }
    it do
      permit(:rating, :body)
          .for(:create, params: comment_params)
    end
  end

end
