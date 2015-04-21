require "rails_helper"

class TestMailer < ActionMailer::Base
  layout "mail"
  enable_mailer_template
  default from: "Newsletter"

  def test_mail
    system_mail_with_tag("test_tag", "a@b.com")
  end
end

RSpec.describe TestMailer, :type => :mailer do

  let(:mail_template) {FactoryGirl.create(:mail_template, tag_list:"test_tag,system")}
  before{mail_template}

  context "for mail_template with tag" do
    subject{TestMailer.test_mail}

    it { expect(subject.subject) .to eq mail_template.subject }

  end


end
