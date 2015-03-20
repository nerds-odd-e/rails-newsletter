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
        end
      end
    end
  end

  module Newsmailerable

    def system_mail_with_tag(tag, email, default = nil)
      @newsletter = ::Newsletter::Newsletter.tagged_with([tag,"system"]).last || default
      raise "No newsletter with the tag '#{tag}, please add it." if not @newsletter
      mail(to: email, subject: render(partial:"/newsletter/news_mailer/extend", locals:{body:@newsletter.subject}).strip, template_path:"newsletter/news_mailer", template_name:"news_mail")
    end

  end
end

