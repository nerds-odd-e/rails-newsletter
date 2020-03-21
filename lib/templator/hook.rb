# frozen_string_literal: true

module Templator
  class Hooks
    def self.init
      ActiveSupport.on_load(:action_mailer) do
        require 'templator/action_mailer/newsmailerable'
        ::ActionMailer::Base.include ::Templator::ActionMailer::MailerTemplating
      end
    end
  end
end
