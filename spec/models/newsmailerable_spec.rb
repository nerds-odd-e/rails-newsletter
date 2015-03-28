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

  let(:newsletter) {FactoryGirl.create(:newsletter, tag_list:"test_tag,system")}
  before{newsletter}

  context "for newsletter with tag" do
    subject{TestMailer.test_mail}

    it { expect(subject.subject) .to eq newsletter.subject }

  end


end
