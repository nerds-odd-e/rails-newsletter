class Newsletter::Newsletter < ActiveRecord::Base
    validates :subject, :body, :presence => true
    attr_accessor :groups
end
