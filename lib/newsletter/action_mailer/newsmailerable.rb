require 'active_support/concern'
require 'active_support/core_ext/array/extract_options'
require 'active_support/deprecation/reporting'

module Newsletter
  module ActionMailer
    module Newsmailerize
      extend ActiveSupport::Concern

      module ClassMethods
        def newsmailerize
          include ::Newsletter::Newsmailerable
          include ::Newsletter::MailerHelper
        end
      end
    end
  end

  module Newsmailerable

    def system_mail_with_tag(tag, email, default = nil)
      @newsletter = ::Newsletter::Newsletter.tagged_with([tag,"system"]).last || default
      raise "No newsletter with the tag '#{tag}, please add it." if not @newsletter
      newsletter_mail(email, @newsletter)
    end

    def newsletter_mail(email, newsletter)
      mail(to: email, subject: newsletter_render(newsletter.subject).strip, body:newsletter_render(newsletter.body))
    end

    def newsletter_render(raw)
      raw.gsub(/\{\{([\w\d_]+)\}\}/){|match| mail_content_for(match[/\{\{([\w\d_]+)\}\}/, 1].to_sym) || "**Missing content '#{match}'**"}
    end
  end

  module MailerHelper

    def mail_content_for(content)
      if content == :email
        @contactable and @contactable.email
      end
    end
  end
end

