class Newsletter::MailTemplate < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  validates :subject, :body, presence: true
  acts_as_taggable

  def render_subject(env)
    template_render(subject, env).strip
  end

  def render_body(env)
    template_render(body, env)
  end

  def method_missing(method, *args, &block)
    if (method.to_s.end_with?('_path') || method.to_s.end_with?('_url')) && main_app.respond_to?(method)
      main_app.send(method, *args)
    else
      super
    end
  end

  private

  def template_render(raw, env)
    recursor = /\{\{((?:[^{}]++|\{\g<1>\})++)\}\}/
    re = /^\s*(not)?\s*([\w\d_]+)(\??)((?:\s|(?:\&nbsp\;))?(.*))?/m
    raw.gsub(recursor) do |match|
      match = match[recursor, 1]
      mail_content_for(match[re, 1], match[re, 3].present?, match[re, 2].to_sym, match[re, 5], env)
    end
  end

  def mail_content_for(_not, question, content, arg, env)
    if env.respond_to? content
      result = env.send(content)
    else
      if env.try(:content_for?, content)
        result = env.content_for(content)
      else
        raise "**Missing content '{{#{content}}}'**"
      end
    end
    if (result.nil? ^ _not.nil?) && (question || strip_tags(arg).present?)
      template_render(arg, env)
    else
      result if _not.nil?
    end
  end
end
