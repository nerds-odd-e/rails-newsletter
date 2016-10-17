source 'https://rubygems.org'

# Declare your gem's dependencies in newsletter.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec
gem "haml-rails"
gem 'responders', '~> 2.0'
gem 'ckeditor'
group :development, :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails', :require => false
  gem "letter_opener"
  gem 'rails-controller-testing'
end

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]
