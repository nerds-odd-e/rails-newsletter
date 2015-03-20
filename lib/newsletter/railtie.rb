module Newsletter
  class Railtie < ::Rails::Railtie
    initializer 'newsletter.initialize' do
      Newsletter::Hooks.init
    end
  end
end

