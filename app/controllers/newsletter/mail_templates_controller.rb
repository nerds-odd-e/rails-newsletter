class Newsletter::MailTemplatesController < ApplicationController
  layout "newsletter/mail_templates"
  before_action :set_locale
  before_action :set_newsletter, only: [:show, :edit, :update, :destroy]

  respond_to :html

  # GET /mail_templates
  def index
    @mail_templates = Newsletter::MailTemplate.all
  end

  def tag
    @tag = params[:tag_id]
    @mail_templates = Newsletter::MailTemplate.tagged_with(@tag)
    render "index"
  end

  # GET /mail_templates/1
  def show
  end

  # GET /mail_templates/new
  def new
    @mail_template = Newsletter::MailTemplate.new
  end

  # GET /mail_templates/1/edit
  def edit
  end

  # POST /mail_templates
  def create
    @mail_template = Newsletter::MailTemplate.new(newsletter_params)
    newsletter_action
  end


  # PATCH/PUT /mail_templates/1
  def update
    @mail_template.assign_attributes(newsletter_params)
    newsletter_action
  end

  # DELETE /mail_templates/1
  def destroy
    @mail_template.destroy
    respond_with(@mail_template)
  end

  def self.method_missing(method, *args, &block)
    if (method.to_s.end_with?('_path') || method.to_s.end_with?('_url')) && main_app.respond_to?(method)
      main_app.send(method, *args)
    else
      super
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_newsletter
    @mail_template = Newsletter::MailTemplate.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def newsletter_params
    params.require(:mail_template).permit(:subject, :body, :tag_list, :groups=>[])
  end

  def user
    current_user
  end

  def set_locale
  end

  # POST /mail_templates
  def newsletter_action
    if @mail_template.valid?
      if params[:preview]
        Newsletter::NewsMailer.news_mail(@mail_template, user).deliver_now
        flash[:notice] = "Preview email has been sent. Please check your mailbox."
        return render :new
      end
      if params[:send_groups]
        count = 0
        @mail_template.groups.reject {|x| x.empty?}.collect do |gp|
          Newsletter.user_class.group(gp)
        end.flatten.each do |user|
          count += 1
          Newsletter::NewsMailer.news_mail(@mail_template, user).deliver_now
        end
        flash[:notice] = "#{count} emails sent."
        return render :new
      end
    end
    @mail_template.save
    respond_with(@mail_template)
  end

end
