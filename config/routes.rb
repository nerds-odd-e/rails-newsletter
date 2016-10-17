Newsletter::Engine.routes.draw do
  resources :mail_templates
  get 'mail_templates/tag/:tag_id' => 'mail_templates#tag', as: 'tagged'
end
