module Newsletter
  class Hooks
    def self.init
      ActiveSupport.on_load(:action_mailer) do
        require 'newsletter/action_mailer/newsmailerable'
        ::ActionMailer::Base.send :include, Newsletter::ActionMailer::MailerTemplating
      end
    end
  end
end
