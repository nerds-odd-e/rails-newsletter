require "rails_helper"

class MailerForTest < ActionMailer::Base
  layout "mail"
  enable_mailer_template
  default from: "me"
  def test_mail(newsletter)
    mail_from_template("fake@n.com", newsletter)
  end

end

module Newsletter
  RSpec.describe "newsmailerize", :type => :mailer do

    let(:newsletter) {FactoryGirl.build(:newsletter)}
    subject{
      newsletter.body = @body
      MailerForTest.test_mail(newsletter).body.to_s}

    it {@body = "abc"
        is_expected.to eq "abc"}

    it {@body = "{{not_exist}}"
        is_expected.to eq "**Missing content '{{not_exist}}'**"}

    context "given there is a content helper" do
      before {
        MailerTemplateHelper.send(:define_method, "new_content") {"default"}
      }

      it {
        @body = "{{new_content}}"
        is_expected.to eq "default"}

      it {
        @body = "{{  new_content  }}"
        is_expected.to eq "default"}

      it {
        @body = "{{new_content arg}}"
        is_expected.to eq "arg"}

      it {
        @body = "{{new_content This is {{new_content}}}}"
        is_expected.to eq "This is default"}

      it {
        @body = "{{new_content I can still use {this} in my content}}"
        is_expected.to eq "I can still use {this} in my content"}

    end

    context "given there is a content helper returns nil" do
      before {
        MailerTemplateHelper.send(:define_method, "new_content") {}
      }

      it {
        @body = "{{new_content arg}}"
        is_expected.to eq ""}
    end

  end
end

