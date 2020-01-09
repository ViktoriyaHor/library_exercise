# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe 'route' do
    it { expect(GET: '/').to route_to controller: 'static_pages', action: 'index' }
  end

  describe 'actions' do
    context '#index' do
      subject! { get :index }
      3.times do |i|
        i += 1
        let!(:"comment_with_rating_#{i}") { create(:comment_with_rating, rating: i) }
      end
      it 'returns a successful response to GET' do
        expect(response).to have_http_status 200
      end
      it 'render template :index' do
        expect(response).to render_template :index
      end
      it 'assigns @comments' do
        expect(assigns(:comments).to_a).to eq [{ '_id' => BSON::ObjectId(comment_with_rating_3.book.id), 'rating' => 3 },
                                               { '_id' => BSON::ObjectId(comment_with_rating_2.book.id), 'rating' => 2 },
                                               { '_id' => BSON::ObjectId(comment_with_rating_1.book.id), 'rating' => 1 }]
      end
    end
  end
end
