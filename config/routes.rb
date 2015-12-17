Rails.application.routes.draw do

  root 'announces#index'

  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  get 'signup' => 'users#new'

  resources :users do
    member do
      #get :following, :followers
      get :get_stuhomeworks
      get :get_my_topic
      get :get_my_question
    end
  end
  # 访问登录页面
  get 'login' => 'sessions#new'
  # 提交用户名和密码的登录请求
  post 'login' => 'sessions#create'
  # 退出登录
  delete 'logout' => 'sessions#destroy'
  # 公告
  resources :announces
  # 问题和回答
  resources :questions do
    resources :answers, only: [:create]
  end
  resources :answers, only: [:edit, :update, :destroy]

  # 课件
  resources :coursewares

  # 作业
  resources :homeworks do
    resources :stuhomeworks, only: [:create]
  end

  resources :stuhomeworks, only: [:edit, :update, :destroy] do
    member do
      get :check
      get :get_stuhomeworks
      patch :check_complete
    end
  end

  # 通知
  resources :notifications, only: [:index, :destroy, :clear]

  resources :stuclasses

  # 关注关系
  resources :relationships, only: [:create, :destroy]

  get 'stu_home' => 'users#stu_home'

  # 验证码
  mount RuCaptcha::Engine => "/rucaptcha"

  # 评论
  resources :comments, only: [:create, :edit, :update, :destroy]

  # 讨论话题
  resources :topics

  # admin用户
  namespace :admin do
    root 'pages#index'
    resources :users, only: [:index, :edit, :update, :destroy]
    resources :announces, only: [:index, :edit, :update, :destroy]
    resources :coursewares, only: [:index, :edit, :update, :destroy]
    resources :stuclasses do
      member do
        get :remove_student
      end
    end

    resources :topics, only: [:index, :edit, :update, :destroy] do
      member do
        get :show_comments
      end
    end

    resources :questions, only: [:index, :edit, :update, :destroy] do
      resources :answers, only: [:index]
    end
    resources :answers, only: [:edit, :update, :destroy] do
      member do
        get :show_comments
      end
    end

    # resources :answers, only: [:edit, :update, :destro]

    resources :homeworks, only: [:index, :edit, :update, :destroy] do
      resources :stuhomeworks, only: [:index]
    end
    resources :stuhomeworks, only: [:edit, :update, :destroy]
    resources :comments
  end

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
