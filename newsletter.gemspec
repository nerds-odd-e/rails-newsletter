$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'newsletter/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'newsletter'
  s.version     = Newsletter::VERSION
  s.authors     = ['Terry Yin']
  s.email       = ['terry@odd-e.com']
  s.homepage    = 'http://less.works'
  s.summary     = 'Summary of Newsletter.'
  s.description = 'Description of Newsletter.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '>=5.0.0.1', '<5.1'
  s.add_dependency 'haml-rails'
  s.add_dependency 'simple_form'
  s.add_dependency 'responders'
  s.add_dependency 'rails-i18n'
  s.add_dependency 'i18n'
  s.add_dependency 'ckeditor'
  s.add_dependency 'acts-as-taggable-on'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
