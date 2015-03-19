class Newsletter::NewslettersController < ApplicationController
  layout "newsletter/newsletters"
  before_action :set_locale
  before_action :set_newsletter, only: [:show, :edit, :update, :destroy]

  respond_to :html

  # GET /newsletters
  def index
    @newsletters = Newsletter::Newsletter.all
  end

  def tag
    @tag = params[:tag_id]
    @newsletters = Newsletter::Newsletter.tagged_with(@tag)
    render "index"
  end

  # GET /newsletters/1
  def show
  end

  # GET /newsletters/new
  def new
    @newsletter = Newsletter::Newsletter.new
  end

  # GET /newsletters/1/edit
  def edit
  end

  # POST /newsletters
  def create
    @newsletter = Newsletter::Newsletter.new(newsletter_params)
    newsletter_action
  end


  # PATCH/PUT /newsletters/1
  def update
    @newsletter.assign_attributes(newsletter_params)
    newsletter_action
  end

  # DELETE /newsletters/1
  def destroy
    @newsletter.destroy
    respond_with(@newsletter)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_newsletter
    @newsletter = Newsletter::Newsletter.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def newsletter_params
    params.require(:newsletter).permit(:subject, :body, :tag_list, :groups=>[])
  end

  def user
    current_user
  end

  def set_locale
  end

  # POST /newsletters
  def newsletter_action
    if @newsletter.valid?
      if params[:preview]
        Newsletter::NewsMailer.news_mail(@newsletter, user).deliver_now
        flash[:notice] = "Preview email has been sent. Please check your mailbox."
        return render :new
      end
      if params[:send_groups]
        count = @newsletter.groups.reject {|x| x.empty?}.collect do |gp|
          Newsletter.user_class.group(gp)
        end.flatten.in_groups_of(10, false).collect do |subgroup|
          subgroup.each do |user|
            Newsletter::NewsMailer.news_mail(@newsletter, user).deliver_now
          end.count
        end.reduce do |sum, e|
          sleep 10.0
          sum + e
        end || 0
        flash[:notice] = "#{count} emails sent."
        return render :new
      end
    end
    @newsletter.save
    respond_with(@newsletter)
  end

end
