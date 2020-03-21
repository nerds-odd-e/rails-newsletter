# frozen_string_literal: true

class Templator::MailTemplatesController < ApplicationController
  layout 'templator/mail_templates'
  before_action :set_newsletter, only: %i[show edit update destroy]

  respond_to :html

  # GET /mail_templates
  def index
    @mail_templates = Templator::MailTemplate.all
  end

  # GET /mail_templates/1
  def show; end

  # GET /mail_templates/new
  def new
    @mail_template = Templator::MailTemplate.new
  end

  # GET /mail_templates/1/edit
  def edit; end

  # POST /mail_templates
  def create
    @mail_template = Templator::MailTemplate.new(newsletter_params)
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_newsletter
    @mail_template = Templator::MailTemplate.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def newsletter_params
    params.require(:mail_template).permit(:subject, :body, :name)
  end

  # POST /mail_templates
  def newsletter_action
    @mail_template.save
    respond_with(@mail_template)
  end
end
