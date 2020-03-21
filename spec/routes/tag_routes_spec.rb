# frozen_string_literal: true

require 'rails_helper'

module Templator
  RSpec.describe MailTemplatesController, type: :routing do
    routes { Engine.routes }

    it { expect(tagged_path(1)).to eq('/templator/mail_templates/tag/1') }
  end
end
