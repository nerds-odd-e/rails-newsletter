Rails.application.routes.draw do
  mount Templator::Engine => '/templator'
end
