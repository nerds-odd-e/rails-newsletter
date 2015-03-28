class Newsletter::Newsletter < ActiveRecord::Base
  include ::Newsletter::MailerTemplateHelper
  validates :subject, :body, :presence => true
  acts_as_taggable
  attr_accessor :groups

  def render_subject(env)
    template_render(subject, env).strip
  end

  def render_body(env)
    template_render(body, env)
  end

  private
  def template_render(raw, env)
    recursor = /\{\{((?:[^{}]++|\{\g<1>\})++)\}\}/
    re = /([\w\d_]+)(\s*)(.*)/
    raw.gsub(recursor){|match|
      match = match[recursor, 1].strip
      mail_content_for(match[re, 1].to_sym, match[re, 3], env)}
  end

  def mail_content_for(content, arg, env)
    if env.respond_to? content
      result = env.send(content)
    else
      if env.try(:content_for?, content)
        result = env.content_for(content)
      else
        return "**Missing content '{{#{content}}}'**"
      end
    end
    if result and !arg.empty?
      template_render(arg, env)
    else
      result
    end
  end


end

