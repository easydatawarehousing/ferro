Rails.application.routes.draw do
  root to: 'home#index'

  if Rails.env.development?
    get 'main_content.json', to: 'home#content'
  end

  get '*path', to: 'home#index', via: :all
end
