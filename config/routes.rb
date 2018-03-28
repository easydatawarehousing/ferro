Rails.application.routes.draw do
  root to: 'home#index'

  if Rails.env.development?
    get 'ferro/main_content.json', to: 'home#content'
    post 'post_test',              to: 'home#post_test'
  end

  get '*path', to: 'home#index', via: :all
end
