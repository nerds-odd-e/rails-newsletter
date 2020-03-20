require 'rails_helper'

class MailerForTest < ActionMailer::Base
  layout 'mail'
  enable_mailer_template
  default from: 'me'
  def test_mail(mail_template, options = {})
    mail_from_template('fake@n.com', mail_template, options)
  end
end

module MyKeywords
  def new_content
    'default'
  end

  def nested_content
    '{{new_content}}'
  end

  def empty_content
  end

  def course_photo
    url = add_or_retrieve_inline_attachment_url('photo1', "xxxxx")
    url
  end
end

module Templator
  RSpec.describe 'newsmailerized mail', type: :mailer do
    let(:body) { 'abc' }
    let(:mail_template) { FactoryGirl.build(:mail_template, body: body) }
    let(:options) { {} }
    let(:mail) { MailerForTest.test_mail(mail_template, options) }
    subject { mail }

    describe 'options' do
      let(:options) {{ cc: 'me' }}

      it do
        expect(subject.cc).to include 'me'
      end
    end

    describe 'body' do
      let(:options) { {} }
      let(:body) { @body }
      subject { mail.body.to_s }

      it do
        @body = 'abc'
        is_expected.to eq "abc\n"
      end

      it do
        @body = '{{non_exist}}'
        expect { subject }.to raise_error "**Missing content '{{non_exist}}'**"
      end

      context 'given there is a content helper' do
        before do
          MailerForTest.load_keywords(MyKeywords)
        end

        it do
          @body = '{{new_content}}'
          is_expected.to eq "default\n"
        end

        it do
          @body = '{{nested_content}}'
          is_expected.to eq "default\n"
        end

        describe 'method on an object' do
          before { @body = '{{an_object.instance_method}}' }

          it { expect { subject }.to raise_error "**Missing content '{{an_object.instance_method}}'**" }

          describe 'when the object exist' do
            let(:the_object) { double }
            let(:options) { { an_object: the_object }}
            before { allow(the_object).to receive(:instance_method) { 'I am called' }}
            it { is_expected.to eq "I am called\n" }
          end
        end

        it do
          @body = '{{new_content?}}'
          is_expected.to eq ''
        end

        it do
          @body = '{{  new_content  }}'
          is_expected.to eq "default\n"
        end

        it do
          @body = '{{  new_content<span>}}'
          is_expected.to eq "default\n"
        end

        it do
          @body = '{{  new_content? <hr/>}}'
          is_expected.to eq "<hr/>\n"
        end

        it do
          @body = '{{new_content arg}}'
          is_expected.to eq "arg\n"
        end

        it do
          @body = "{{new_content \narg\narg}}"
          is_expected.to eq "\narg\narg\n"
        end

        it do
          @body = '{{new_content&nbsp;arg}}'
          is_expected.to eq "arg\n"
        end

        it do
          @body = '{{new_content  arg }}'
          is_expected.to eq " arg \n"
        end

        it do
          @body = '{{new_content This is {{new_content}}}}'
          is_expected.to eq "This is default\n"
        end

        it do
          @body = '{{new_content I can still use {this} in my content}}'
          is_expected.to eq "I can still use {this} in my content\n"
        end

        it do
          @body = '{{not new_content arg}}'
          is_expected.to eq ''
        end
      end

      context 'given there is a content helper returns nil' do
        it do
          @body = '{{empty_content arg}}'
          is_expected.to eq ''
        end

        it do
          @body = '{{not empty_content arg}}'
          is_expected.to eq "arg\n"
        end
      end
    end

    describe 'attachments' do
      def email_body(email)
        email.body.parts.detect{|p| p.content_type.match(/text\/html/)}.body
      end
      let(:body) { 'Link to the photo is: {{course_photo}}' }
      it { expect(subject.attachments.count).to eq 1 }
      it { expect(email_body(subject)).to have_content 'cid' }

      context 'when the keyword is called twice' do
        let(:body) { 'Link to the photo is: {{course_photo}} {{course_photo}}' }
        it { expect(subject.attachments.count).to eq 1 }
      end
    end
  end
end
