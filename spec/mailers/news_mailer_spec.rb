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
  end

end
