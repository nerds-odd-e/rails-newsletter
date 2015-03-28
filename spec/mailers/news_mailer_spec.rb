require "rails_helper"

module Newsletter
  RSpec.describe NewsMailer, :type => :mailer do

    let(:newsletter) {FactoryGirl.build(:newsletter)}
    subject {NewsMailer.news_mail newsletter, double(email:"t@t.com")}

    it "should have the newsletter body" do
      expect(subject.body.to_s).to include newsletter.body
      expect(subject.subject).to eq newsletter.subject
    end

    it "should have the html" do
      newsletter.body = "<strong>Sin!</strong>"
      expect(subject.body.to_s).to include newsletter.body
    end

    it "render placeholder" do
      newsletter.body = "{{email}}"
      expect(subject.body.to_s).to include "t@t.com"
    end

    it "renders missing placeholder" do
      newsletter.body = "{{missing_content}}"
      expect{subject.body.to_s}.to raise_error
    end

    it "render placeholder in subject" do
      newsletter.subject = "{{email}}"
      expect(subject.subject.to_s).to include "t@t.com"
    end

    context "for newsletter with tag" do
      let(:newsletter) {FactoryGirl.create(:newsletter, tag_list:"abc,system")}
      before{newsletter}

      it {
        expect(NewsMailer.system_mail_with_tag("abc", double(email:"t@t.com")).subject)
          .to eq newsletter.subject
      }

      it {
        expect{NewsMailer.system_mail_with_tag("not_exist", double(email:"t@t.com")).subject}
          .to raise_error
      }

    end

  end

end
