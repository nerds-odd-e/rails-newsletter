require 'rails_helper'

class User
  def self.categories
    %w(Users Contacts)
  end

end

RSpec.describe "Newsletters", :type => :request do

  describe "/newsletter/newsletters/new" do
    it "works! (now write some real specs)" do
      Newsletter.user_class = User
      get subject
      expect(response).to have_http_status(200)
      assert_select "#newsletter_groups_users", count:1
    end
  end
end
