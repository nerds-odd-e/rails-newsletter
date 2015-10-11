class Newsletter::MassMailsController < ApplicationController
  layout "newsletter/mail_templates"
  respond_to :html

  def new
    @mass_mail = Newsletter::MassMail.new
  end

  def create
    @mass_mail = Newsletter::MassMail.new(mass_mail_params)
    newsletter_action
  end

  # Only allow a trusted parameter "white list" through.
  def mass_mail_params
    params.require(:mass_mail).permit(:subject, :body, :groups=>[])
  end

  def user
    current_user
  end

  # POST /mail_templates
  def newsletter_action
    if @mass_mail.valid?
      send_mail(Newsletter::MailTemplate.new subject:@mass_mail.subject, body:@mass_mail.body)
    end
    render "new"
  end

  def send_mail(mail_template)
    if params[:preview]
      Newsletter::NewsMailer.news_mail(mail_template, user).deliver_now
      flash[:notice] = "Preview email has been sent. Please check your mailbox."
    end
    if params[:send_groups]
      count = 0
      @mass_mail.groups.reject {|x| x.empty?}.collect do |gp|
        Newsletter.user_class.group(gp)
      end.flatten.each do |user|
        count += 1
        Newsletter::NewsMailer.news_mail(mail_template, user).deliver_now
      end
      flash[:notice] = "#{count} emails sent."
    end
  end

end

