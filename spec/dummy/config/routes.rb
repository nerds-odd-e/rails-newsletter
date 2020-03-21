# frozen_string_literal: true

Rails.application.routes.draw do
  mount Templator::Engine => '/templator'
end
