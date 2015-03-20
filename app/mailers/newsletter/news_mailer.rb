class Newsletter::NewsMailer < ActionMailer::Base
  newsmailerize
  default from: "Newsletter"

  def news_mail(newsletter, user)
    @newsletter = newsletter
    @contactable = user
    mail(to: user.email, subject: render(partial:"extend", locals:{body:@newsletter.subject}).strip, template_path:"newsletter/news_mailer", template_name:"news_mail")
  end

end
