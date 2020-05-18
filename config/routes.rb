Rails.application.routes.draw do
  resources :comments
  resources :profiles
  resources :authors
  resources :books
  post 'books/:id/increment' => 'books#increment', as: :book_increment
  post 'books/:id/decrement' => 'books#decrement', as: :book_decrement
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
