require 'rails_helper'

class TestMailer < ActionMailer::Base
  layout 'mail'
  enable_mailer_template
  default from: 'Templator'

  def test_mail
    system_mail_with_tag('test_tag', 'a@b.com')
  end
end

RSpec.describe TestMailer, type: :mailer do
  let(:mail_template) { FactoryGirl.create(:mail_template, name: 'test_tag') }
  before { mail_template }

  context 'for mail_template with tag' do
    subject { TestMailer.test_mail }

    it { expect(subject.subject) .to eq mail_template.subject }
  end
end
