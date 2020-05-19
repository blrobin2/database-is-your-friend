Rails.application.routes.draw do
  resources :comments
  resources :profiles
  resources :authors
  resources :books
  post 'books/:id/increment' => 'books#increment', as: :book_increment
  post 'books/:id/decrement' => 'books#decrement', as: :book_decrement
  post 'books/:id/move_up' => 'books#move_up', as: :book_move_up
  post 'books/:id/move_down' => 'books#move_down', as: :book_move_down
  post 'books/:id/move_to_top' => 'books#move_to_top', as: :book_move_to_top
  post 'books/:id/move_to_bottom' => 'books#move_to_bottom', as: :book_move_to_bottom
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
