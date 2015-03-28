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
      newsletter = ::Newsletter::Newsletter.tagged_with([tag,"system"]).last || default
      raise "No newsletter with the tag '#{tag}, please add it." if not newsletter
      mail_from_template(email, newsletter.subject, newsletter.body)
    end

    def mail_from_template(email, subject, body)
      mail(to: email, subject: template_render(subject).strip, body:template_render(body))
    end

    def template_render(raw)
      recursor = /\{\{((?:[^{}]++|\{\g<1>\})++)\}\}/
      re = /([\w\d_]+)(\s*)(.*)/
      raw.gsub(recursor){|match|
        match = match[recursor, 1].strip
        mail_content_for(match[re, 1].to_sym, match[re, 3])}
    end

    def mail_content_for(content, arg)
      return "**Missing content '{{#{content}}}'**" if !::Newsletter::MailerTemplateHelper.public_instance_methods.include? content
      result = send(content)
      if result and !arg.empty?
        template_render(arg)
      else
        result
      end
    end

  end

  module MailerTemplateHelper

    def email
      @contactable and @contactable.email
    end

  end
end

