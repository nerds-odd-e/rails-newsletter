Newsletter::Engine.routes.draw do
  resources :newsletters
  get "newsletters/tag/:tag_id"=>"newsletters#tag", as:"tagged"

end
