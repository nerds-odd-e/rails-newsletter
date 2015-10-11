require "rails_helper"

class NewsMailer < ActionMailer::Base
  enable_mailer_template
  load_keywords ::Newsletter::MailerTemplateHelper
  default from: "me"
  layout "mail"

end

module Newsletter
  RSpec.describe NewsMailer, :type => :mailer do

    let(:mail_template) {FactoryGirl.build(:mail_template)}

    context "for mail_template with tag" do
      let(:mail_template) {FactoryGirl.create(:mail_template, tag_list:"abc,system")}
      before{mail_template}

      it {
        expect(NewsMailer.system_mail_with_tag("abc", double(email:"t@t.com")).subject)
          .to eq mail_template.subject
      }

      it {
        expect(NewsMailer.system_mail_with_tag("abc", double(email:"t@t.com"), nil, cc:"cc").cc)
          .to eq ["cc"]
      }

      it {
        expect{NewsMailer.system_mail_with_tag("not_exist", double(email:"t@t.com")).subject}
          .to raise_error
      }

    end

  end

end
