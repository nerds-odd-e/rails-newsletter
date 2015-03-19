class Newsletter::Newsletter < ActiveRecord::Base
    validates :subject, :body, :presence => true
    acts_as_taggable
    attr_accessor :groups
end
