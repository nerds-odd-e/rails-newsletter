class Newsletter::NewsMailer < ActionMailer::Base
  default from: "Newsletter"

  def last_mail_with_tag(tag, user)
    last_mail = Newsletter::Newsletter.tagged_with(tag).last
    news_mail(last_mail, user) if last_mail
  end

  def news_mail(newsletter, user)
    @newsletter = newsletter
    @contactable = user
    mail(to: user.email, subject: render(partial:"extend", locals:{body:@newsletter.subject}).strip, template_name:"news_mail")
  end

end
