require 'templator/template_it'

class Templator::MailTemplate < ActiveRecord::Base
  validates :subject, :body, presence: true
  validates :name, presence: true, uniqueness: true
  self.table_name = 'newsletter_mail_templates'

  def render_subject(options)
    Templator::TemplateIt.new(options).render(subject).strip
  end

  def render_body(options)
    Templator::TemplateIt.new(options).render(body)
  end

  def method_missing(method, *args, &block)
    if (method.to_s.end_with?('_path') || method.to_s.end_with?('_url')) && main_app.respond_to?(method)
      main_app.send(method, *args)
    else
      super
    end
  end
end

