require 'rails_helper'

module Newsletter
  RSpec.describe MailTemplatesController, type: :routing do
    routes { Engine.routes }

    it { expect(tagged_path(1)).to eq('/newsletter/mail_templates/tag/1') }
  end
end
