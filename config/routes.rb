Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  resources :users, only: [:create] do
    resources :ie_statements, only: [:create, :index, :show] do
      collection do
        get :monthly_statement
        get :monthly_statement_download
      end
    end
  end
  
  post 'auth/login', to: 'authentication#login'
end
