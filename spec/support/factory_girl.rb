RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end

include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :mail_template, class: Templator::MailTemplate do
    subject 'how do you keep your sanity'
    body "I'm losing it."
    name "abc"
  end
end
