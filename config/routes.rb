Rails.application.routes.draw do
  namespace :concerns do
    get 'clans/index'
  end

	require 'sidekiq/web'
	mount Sidekiq::Web => '/sidekiq', as: :sidekiq

	root 'clans#home'
	get 'search' => 'search#index', as: :search

	resources :clans, only: [:index, :show] do
		get :stats, on: :member
		get :members, on: :member
		get :tanks, on: :member
		get :changes, on: :member
	end
end
