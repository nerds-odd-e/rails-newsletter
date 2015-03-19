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

    factory :newsletter, class:Newsletter::Newsletter do
      subject "how do you keep your sanity"
      body "I'm losing it."
    end

  end



