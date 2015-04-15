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
    re = /^\s*(not)?\s*([\w\d_]+)\??((?:\s|(?:\&nbsp\;))?(.*))?/m
    raw.gsub(recursor){|match|
      match = match[recursor, 1]
      mail_content_for(match[re, 1], match[re, 2].to_sym, match[re, 4], env)}
  end

  def mail_content_for(_not, content, arg, env)
    if env.respond_to? content
      result = env.send(content)
    else
      if env.try(:content_for?, content)
        result = env.content_for(content)
      else
        raise "**Missing content '{{#{content}}}'**"
      end
    end
    if (result.nil? ^ _not.nil?) and !arg.blank?
      template_render(arg, env)
    else
      result if _not.nil?
    end
  end


end

