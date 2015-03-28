class Newsletter::NewsMailer < ActionMailer::Base
  newsmailerize
  default from: "Newsletter"

  def news_mail(newsletter, user)
    @newsletter = newsletter
    @contactable = user
    newsletter_mail(user.email, newsletter)
  end

end
