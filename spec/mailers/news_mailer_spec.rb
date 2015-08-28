require "rails_helper"

module Newsletter
  RSpec.describe NewsMailer, :type => :mailer do

    let(:mail_template) {FactoryGirl.build(:mail_template)}
    subject {NewsMailer.news_mail mail_template, double(email:"t@t.com")}

    it "should have the mail_template body" do
      expect(subject.body.to_s).to include mail_template.body
      expect(subject.subject).to eq mail_template.subject
    end

    it "should have the html" do
      mail_template.body = "<strong>Sin!</strong>"
      expect(subject.body.to_s).to include mail_template.body
    end

    it "render placeholder" do
      mail_template.body = "{{email}}"
      expect(subject.body.to_s).to include "t@t.com"
    end

    it "renders missing placeholder" do
      mail_template.body = "{{missing_content}}"
      expect{subject.body.to_s}.to raise_error
    end

    it "render placeholder in subject" do
      mail_template.subject = "{{email}}"
      expect(subject.subject.to_s).to include "t@t.com"
    end

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
