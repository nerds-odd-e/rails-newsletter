$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'templator/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'templator'
  s.version     = Templator::VERSION
  s.authors     = ['Terry Yin']
  s.email       = ['terry@odd-e.com']
  s.homepage    = 'http://less.works'
  s.summary     = 'Summary of Templator.'
  s.description = 'Description of Templator.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'responders'
  s.add_dependency 'rails-i18n'
  s.add_development_dependency 'rails', '>=5.0.0.1', '<5.1'
  s.add_development_dependency 'haml-rails'
  s.add_development_dependency 'simple_form'
  s.add_development_dependency 'i18n'
  s.add_development_dependency 'ckeditor'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'shoulda-matchers'
end
