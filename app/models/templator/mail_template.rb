class Templator::MailTemplate < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  validates :subject, :body, presence: true
  validates :name, presence: true, uniqueness: true
  self.table_name = 'newsletter_mail_templates'

  def render_subject(options)
    template_render(subject, options).strip
  end

  def render_body(options)
    template_render(body, options)
  end

  def method_missing(method, *args, &block)
    if (method.to_s.end_with?('_path') || method.to_s.end_with?('_url')) && main_app.respond_to?(method)
      main_app.send(method, *args)
    else
      super
    end
  end

  private

  def template_render(raw, options)
    recursor = /\{\{((?:[^{}]++|\{\g<1>\})++)\}\}/
    re = /^\s*(not)?\s*([\w\d_\.]+)(\??)((?:\s|(?:\&nbsp\;))?(.*))?/m
    raw&.to_s&.gsub(recursor) do |match|
      match = match[recursor, 1]
      mail_content_for(match[re, 1], match[re, 3].present?, match[re, 2].to_sym, match[re, 5], options)
    end
  end

  def mail_content_for(_not, question, content, arg, options)
    result = extract_content_from_context(content, options)
    if (result.nil? ^ _not.nil?) && (question || strip_tags(arg).present?)
      template_render(arg, options)
    else
      result if _not.nil?
    end
  end

  private

  def extract_content_from_context(content, options)
    env = options[:env]
    return template_render(env.send(content), options) if env.respond_to? content
    return env.content_for(content) if env.try(:content_for?, content)

    if content =~ /(\w+)\.(\w+)/ &&  options.include?($~[1].to_sym)
      return 'I am called'
    end
    raise "**Missing content '{{#{content}}}'**"
  end


end
