require "rails_helper"

module Newsletter
RSpec.describe NewslettersController, :type => :routing do
  routes { Engine.routes }

  it { expect(tagged_path(1)).to eq("/newsletter/newsletters/tag/1") }

end
end



