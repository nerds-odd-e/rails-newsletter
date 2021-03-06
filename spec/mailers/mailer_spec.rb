# frozen_string_literal: true

require 'rails_helper'

class NewsMailer < ActionMailer::Base
  enable_mailer_template
  load_keywords ::Templator::MailerTemplateHelper
  default from: 'me'
  layout 'mail'
end

module Templator
  RSpec.describe NewsMailer, type: :mailer do
    let(:mail_template) { FactoryGirl.build(:mail_template) }

    context 'for mail_template with tag' do
      let(:mail_template) { FactoryGirl.create(:mail_template, name: 'abc') }
      before { mail_template }

      it do
        expect(NewsMailer.system_mail_with_tag('abc', 't@t.com').subject)
          .to eq mail_template.subject
      end

      it do
        expect(NewsMailer.system_mail_with_tag('abc', 't@t.com', nil, cc: 'cc').cc)
          .to eq ['cc']
      end

      it do
        expect { NewsMailer.system_mail_with_tag('not_exist', 't@t.com').subject }
          .to raise_error
      end
    end
  end
end
