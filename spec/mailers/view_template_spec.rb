require 'rails_helper'

module Newsletter
  RSpec.describe 'template from view' do
    let(:mail_template) { FactoryGirl.build(:mail_template, body: @body) }
    let(:view) { double }
    subject do
      mail_template.render_body view
    end

    it do
      @body = 'abc'
      is_expected.to eq 'abc'
    end

    it do
      @body = '{{content}}'
      expect(view).to receive(:respond_to?).with(:content) { false }
      expect(view).to receive(:try).with(:content_for?, :content) { false }
      expect { subject }.to raise_error
    end

    it do
      @body = '{{content}}'
      expect(view).to receive(:respond_to?).with(:content) { false }
      expect(view).to receive(:try).with(:content_for?, :content) { true }
      expect(view).to receive(:content_for).with(:content) { 'abc' }
      is_expected.to eq 'abc'
    end
  end
end
