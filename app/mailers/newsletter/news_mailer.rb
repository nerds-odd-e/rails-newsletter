class Newsletter::NewsMailer < ActionMailer::Base
  layout "mail"
  enable_mailer_template
  load_keywords ::Newsletter::MailerTemplateHelper
  default from: "Newsletter"

  def news_mail(newsletter, user)
    @contactable = user
    mail_from_template(user.email, newsletter)
  end

end
