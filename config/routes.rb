Rails.application.routes.draw do
  devise_for :users
  match "book/:id/take" => "books#take", :via => :patch, as: :book_take
  match "book/:id/return" => "books#return", :via => :patch, as: :book_return

  resources :books do
    resources :comments, only: [:create]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#index'
  match '/uploads/grid/book/cover/:id/:filename' => 'gridfs#cover', :via => :get
end
