# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :find_book
  helper_method :raiting_book

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  private

  def find_book(comment)
    Author.all.map { |a| a.books.find(comment['_id'].to_str) }.compact.first
  end

  def raiting_book(comment)
    id = find_book(comment).id
    ratings_count = Comment.find_by_book(id).not_in(rating: 0).count
    sum_rating = Comment.find_by_book(id).sum(:rating)
    @average_rating = (sum_rating.to_f / ratings_count).round if ratings_count.positive?
  end

end
