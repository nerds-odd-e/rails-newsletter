module Templator
  class Railtie < ::Rails::Railtie
    initializer 'templator.initialize' do
      Templator::Hooks.init
    end
  end
end
