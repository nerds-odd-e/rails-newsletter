class Newsletter::NewsMailer < ActionMailer::Base
  enable_mailer_template
  default from: "Newsletter"

  def news_mail(newsletter, user)
    @contactable = user
    mail_from_template(user.email, newsletter.subject, newsletter.body)
  end

end
