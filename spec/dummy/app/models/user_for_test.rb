class UserForTest < ActiveRecord::Base
  self.table_name = "users"

  def self.categories
    {"odd-e"=>->{where("email like ?", "%@odd-e.com")},
     "non odd-e"=>->{where.not("email like ?", "%@odd-e.com")}}
  end


end
