class Newsletter::NewsMailer < ActionMailer::Base
  layout "mail"
  enable_mailer_template
  load_keywords ::Newsletter::MailerTemplateHelper
  default from: "Newsletter"

  def news_mail(newsletter, email)
    @email = email
    mail_from_template(email, newsletter)
  end

end
