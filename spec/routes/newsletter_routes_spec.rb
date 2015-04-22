require "rails_helper"

module Newsletter
RSpec.describe MassMailsController, :type => :routing do
  routes { Engine.routes }

  it { expect(new_mass_mail_path).to eq("/newsletter/mass_mails/new") }

end
end




