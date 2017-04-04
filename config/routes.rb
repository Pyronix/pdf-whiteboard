Rails.application.routes.draw do
  resources :pdfs do
    get 'download'
    get 'page/:page_id', :action => :show_page, :as => :show_page
  end

  get 'welcome/index'

  root 'welcome#index'
end
