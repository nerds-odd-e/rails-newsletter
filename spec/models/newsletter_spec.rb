require 'rails_helper'

RSpec.describe Templator::MailTemplate, type: :model do
  include Shoulda::Matchers::ActiveModel
  include Shoulda::Matchers::ActiveRecord
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
