module Newsletter
  class NewsMailer < ActionMailer::Base
    default from: "Newsletter"

    def news_mail(newsletter, user)
      @newsletter = newsletter
      @user = user
      mail(to: user.email, subject: @newsletter.subject)
    end

  end
end
