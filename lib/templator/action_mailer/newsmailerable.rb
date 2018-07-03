require 'active_support/concern'
require 'active_support/core_ext/array/extract_options'
require 'active_support/deprecation/reporting'

module Templator
  module ActionMailer
    module MailerTemplating
      extend ActiveSupport::Concern

      module ClassMethods
        def enable_mailer_template
          include ::Templator::MailerTemplatable
        end

        def load_keywords(m)
          include m
        end
      end
    end
  end

  module MailerTemplatable
    def system_mail_with_tag(name, email, default = nil, options = {})
      mail_template = ::Templator::MailTemplate.find_by(name: name) || default
      raise "No mail template with the tag '#{name}, please add it." unless mail_template
      mail_from_template(email, mail_template, options)
    end

    def mail_from_template(email, mail_template, options = {})
      collecting_attachments do
        mail_template.render_body(self)
      end
      mail(to: email,
           subject: mail_template.render_subject(self), **options) do |format|
             format.html { render(html: mail_template.render_body(self).html_safe, layout: true) }
           end
    end

    def add_or_retrieve_inline_attachment_url(filename, data)
      if @collecting_attachments
        attachments.inline[filename] = data unless attachments[filename].present?
      end
      attachments[filename]&.url
    end

    private

    def collecting_attachments(&callback)
      @collecting_attachments = true
      callback.call
    ensure
      @collecting_attachments = false
    end
  end

  module MailerTemplateHelper
    def email
      @email
    end
  end
end
