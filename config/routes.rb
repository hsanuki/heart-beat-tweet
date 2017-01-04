Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations', confirmations: "confirmations"} # ログイン周りに必要なルーティングを一気に生成してくれる
  root 'tweets#index'
  get "tweets/search" => "tweets#search"
  get "users/confirm" => "users#confirm" # 仮メール送信画面結果
  get "users/fitbit_revoke" => "users#fitbit_revoke"

  # get 'tweets' => 'tweets#index' # 一覧表示
  # get   'tweets/new'  =>  'tweets#new'       #投稿画面
  # get 'tweets/:id' => 'tweets#show'       #ツイート詳細画面
  # delete  'tweets/:id'  => 'tweets#destroy'
  # patch   'tweets/:id'  => 'tweets#update'
  # get   'tweets/:id/edit'  => 'tweets#edit'
  # post  'tweets'      =>  'tweets#create'    #ツイート投稿機能
  # resources :tweets
  resources :tweets do
    resources :comments, only: [:create]
  end
  # resources :tweets, only: :show do
  #   collection do
  #     get 'search'
  #   end
  # end

  # get   'users/:id'   =>  'users#show'    #Mypageへのルーティング
  resources :users, only: [:show, :edit, :update]
  get '/auth/:provider/callback' => 'sessions#create' # Fitbit連携成功時（一瞬マイページにディレクトリを移動させるのが正解？）
  get '/auth/failure' => 'tweets#index' # Fitbit連携失敗時

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
