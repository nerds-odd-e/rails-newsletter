require "simple_form"
require "newsletter/engine"

module Newsletter
    #
    # Need a user class to provide the users
    #
    mattr_accessor :user_class

end
