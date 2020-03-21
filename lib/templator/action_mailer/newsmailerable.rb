# frozen_string_literal: true

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
      unless mail_template
        raise "No mail template with the tag '#{name}, please add it."
      end

      mail_from_template(email, mail_template, options)
    end

    def mail_from_template(email, mail_template, options = {})
      options.merge!(env: self)
      collecting_attachments do
        mail_template.render_body(options)
      end
      mail(to: email,
           subject: mail_template.render_subject(options), **options) do |format|
             format.html { render(html: mail_template.render_body(options).html_safe, layout: true) }
           end
    end

    def add_or_retrieve_inline_attachment_url(filename, data)
      if @collecting_attachments
        unless attachments[filename].present?
          attachments.inline[filename] = data
        end
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
