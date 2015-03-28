require 'active_support/concern'
require 'active_support/core_ext/array/extract_options'
require 'active_support/deprecation/reporting'

module Newsletter
  module ActionMailer
    module MailerTemplating
      extend ActiveSupport::Concern

      module ClassMethods
        def enable_mailer_template
          include ::Newsletter::MailerTemplatable
          include ::Newsletter::MailerTemplateHelper
        end
      end
    end
  end

  module MailerTemplatable

    def system_mail_with_tag(tag, email, default = nil)
      newsletter = ::Newsletter::Newsletter.with_system_tag(tag).last || default
      raise "No newsletter with the tag '#{tag}, please add it." if not newsletter
      mail_from_template(email, newsletter)
    end

    def mail_from_template(email, newsletter)
      mail(to: email, subject: newsletter.render_subject(self), body:render(text:newsletter.render_body(self), layout:true).strip)
    end

  end

  module MailerTemplateHelper

    def email
      @contactable and @contactable.email
    end

  end

end

