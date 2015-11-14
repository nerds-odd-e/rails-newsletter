require "rails_helper"

class MailerForTest < ActionMailer::Base
  layout "mail"
  enable_mailer_template
  default from: "me"
  def test_mail(mail_template, options={})
    mail_from_template("fake@n.com", mail_template, options)
  end

end

module MyKeywords
  def new_content
    "default"
  end
  def empty_content
  end
end

module Newsletter
  RSpec.describe "newsmailerize", :type => :mailer do
    let(:mail_template) {FactoryGirl.build(:mail_template)}

    describe "options" do
      subject{
        mail_template.body = @body
        MailerForTest.test_mail(mail_template, @options)}

      it {@body = "abc"
          @options = {cc:"me"}
          expect(subject.cc).to include "me"}

    end

    describe "body" do
      subject{
        mail_template.body = @body
        MailerForTest.test_mail(mail_template).body.to_s}

      it {@body = "abc"
          is_expected.to eq "abc\n"}

      it {@body = "{{not_exist}}"
          expect{subject}.to raise_error}

      context "given there is a content helper" do
        before {
          MailerForTest.load_keywords(MyKeywords)
        }

        it {
          @body = "{{new_content}}"
          is_expected.to eq "default\n"}

        it {
          @body = "{{new_content?}}"
          is_expected.to eq ""}

        it {
          @body = "{{  new_content  }}"
          is_expected.to eq "default\n"}

        it {
          @body = "{{  new_content<span>}}"
          is_expected.to eq "default\n"}

        it {
          @body = "{{  new_content? <hr/>}}"
          is_expected.to eq "<hr/>\n"}

        it {
          @body = "{{new_content arg}}"
          is_expected.to eq "arg\n"}

        it {
          @body = "{{new_content \narg\narg}}"
          is_expected.to eq "\narg\narg\n"}

        it {
          @body = "{{new_content&nbsp;arg}}"
          is_expected.to eq "arg\n"}

        it {
          @body = "{{new_content  arg }}"
          is_expected.to eq " arg \n"}

        it {
          @body = "{{new_content This is {{new_content}}}}"
          is_expected.to eq "This is default\n"}

        it {
          @body = "{{new_content I can still use {this} in my content}}"
          is_expected.to eq "I can still use {this} in my content\n"}

        it {
          @body = "{{not new_content arg}}"
          is_expected.to eq ""}

      end

      context "given there is a content helper returns nil" do

        it {
          @body = "{{empty_content arg}}"
          is_expected.to eq ""}

        it {
          @body = "{{not empty_content arg}}"
          is_expected.to eq "arg\n"}

      end
    end

  end
end

