module Newsletter
  class MassMail < ActiveRecord::Base
    validates :subject, :body, :presence => true
    attr_accessor :groups
  end
end
