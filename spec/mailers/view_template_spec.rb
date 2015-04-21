require "rails_helper"

module Newsletter
  RSpec.describe "template from view" do

    let(:mail_template) {FactoryGirl.build(:mail_template, body:@body)}
    let(:view) {double}
    subject{
      mail_template.render_body view}

    it {@body = "abc"
        is_expected.to eq "abc"}

    it {@body = "{{content}}"
        expect(view).to receive(:respond_to?).with(:content) {false}
        expect(view).to receive(:try).with(:content_for?, :content) {false}
        expect{subject}.to raise_error}

    it {@body = "{{content}}"
        expect(view).to receive(:respond_to?).with(:content) {false}
        expect(view).to receive(:try).with(:content_for?, :content) {true}
        expect(view).to receive(:content_for).with(:content) {"abc"}
        is_expected.to eq "abc"}

  end
end

