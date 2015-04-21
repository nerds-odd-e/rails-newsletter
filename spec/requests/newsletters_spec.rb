require 'rails_helper'

class User
  def self.categories
    %w(Users Contacts)
  end

end

RSpec.describe "Newsletters", :type => :request do

  describe "/newsletter/mail_templates/new" do
    it "works!" do
      Newsletter.user_class = User
      get subject
      expect(response).to have_http_status(200)
      assert_select "#mail_template_groups_users", count:1
    end
  end
end
