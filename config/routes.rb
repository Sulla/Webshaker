Webshaker::Application.routes.draw do
  root :to => "posts#index"

  match 'beta' => 'main#beta'
	match 'about' => 'main#about' 
	match 'faq' => 'main#faq'
	match 'terms' => 'main#terms'
	match 'privacy' => 'main#privacy'
	match 'advertise' => 'main#advertise'
	match 'benjamin' => 'main#benjamin'
	match 'faq' => 'main#faq'
	match 'welcome' => 'main#welcome'
	match 'feed' => 'main#feed'	
	match '/submit' => 'posts#submit'
	match "profiles/:id/portfolio/:project" => "profiles#project"
  devise_for :users, :controllers => { :registrations => "registrations" }
  
  resources :profiles do
    collection do
      get 'submit'
      post 'submit'
      post 'upload_avatar'
      post 'reset_avatar'
      get 'posts'
    end  
  end
  
  resources :companies do
    collection do
      get 'top'
      post 'invite'
    end
    member do
      get 'has_admin'
      get 'employees'
      post 'reset_avatar'
    end
  end
  resources :schools
  resources :workers do
    collection do
      post 'admin_request'
    end
    member do
      post 'accept'
      post 'refuse'
    end
  end
  resources :links
  resources :posts do
    collection do
      get 'top'
    end
    member do
      get 'repost'
      post 'visibility'      
    end
  end
  resources :comments
  resources :bookmarks
  resources :likes  
  resources :attachments
  resources :activities  
  
  resources :alerts, :only => [:create]
  
  match 'jobs' => 'jobs#index'
  match 'jobs/map' => 'jobs#map'  
  
  match 'directory' => 'directory#index'
  match 'directory/map' => 'directory#map'  
  match 'directory/search' => 'directory#search'
  
  match 'search' => 'search#index'
  
  namespace :admin do
    root :to => "posts#index"
    match 'main/mailing' => 'main#mailing'
    resources :users
    resources :codes    
    resources :workers
    resources :posts do
      member do
        post 'visibility'
        post 'validate'
      end
    end
    resources :comments
    resources :companies do
      member do
        post 'visibility'
      end
    end      
    resources :schools do
      member do
        post 'visibility'
      end
    end    
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
