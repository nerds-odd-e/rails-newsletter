# frozen_string_literal: true

module Templator
  class TemplateIt
    include ActionView::Helpers::SanitizeHelper

    def initialize(options)
      @options = options
    end

    def render(raw)
      recursor = /\{\{((?:[^{}]++|\{\g<1>\})++)\}\}/
      re = /^\s*(not)?\s*([\w\d_\.]+)(\??)((?:\s|(?:\&nbsp\;))?(.*))?/m
      raw&.to_s&.gsub(recursor) do |match|
        match = match[recursor, 1]
        mail_content_for(match[re, 1], match[re, 3].present?, match[re, 2].to_sym, match[re, 5])
      end
    end

    private

    def mail_content_for(_not, question, content, arg)
      result = extract_content_from_context(content)
      if (result.nil? ^ _not.nil?) && (question || strip_tags(arg).present?)
        render(arg)
      else
        result if _not.nil?
      end
    end

    def extract_content_from_context(content)
      env = @options[:env]
      return render(env.send(content)) if env&.respond_to? content
      return env.content_for(content) if env.try(:content_for?, content)

      if content =~ /(\w+)\.(\w+)/
        object = $LAST_MATCH_INFO[1].to_sym
        method = $LAST_MATCH_INFO[2]
        if @options.include?($LAST_MATCH_INFO[1].to_sym)
          return (@options[object].try(:decorate, context: {mailer: env}) || @options[object]).send(method)
        end
      end
      raise "**Missing content '{{#{content}}}'**"
    end
  end
end
