# frozen_string_literal: true

require 'rails_helper'

module Templator
  RSpec.describe MailTemplatesController, type: :controller do
    routes { Engine.routes }

    let(:valid_attributes) do
      FactoryGirl.build(:mail_template).attributes
    end

    let(:invalid_attributes) do
      FactoryGirl.build(:mail_template, subject: nil).attributes
    end

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # MailTemplatesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe 'GET index' do
      it 'assigns all mail_templates as @mail_templates' do
        mail_template = MailTemplate.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:mail_templates)).to eq([mail_template])
      end
    end

    describe 'GET show' do
      it 'assigns the requested mail_template as @mail_template' do
        mail_template = MailTemplate.create! valid_attributes
        get :show, { id: mail_template.to_param }, valid_session
        expect(assigns(:mail_template)).to eq(mail_template)
      end
    end

    describe 'GET new' do
      it 'assigns a new mail_template as @mail_template' do
        get :new, {}, valid_session
        expect(assigns(:mail_template)).to be_a_new(MailTemplate)
        expect(response).to render_template(layout: 'templator/mail_templates')
      end
    end

    describe 'GET edit' do
      it 'assigns the requested mail_template as @mail_template' do
        mail_template = MailTemplate.create! valid_attributes
        get :edit, { id: mail_template.to_param }, valid_session
        expect(assigns(:mail_template)).to eq(mail_template)
      end
    end

    describe 'POST create' do
      describe 'with valid params' do
        it 'creates a new MailTemplate' do
          expect do
            post :create, { mail_template: valid_attributes }, valid_session
          end.to change(MailTemplate, :count).by(1)
        end

        it 'add tags to the mail_template' do
          post :create, { mail_template: valid_attributes.merge(name: 'abc') }, valid_session
          expect(assigns(:mail_template).name).to eq 'abc'
        end

        it 'assigns a newly created mail_template as @mail_template' do
          post :create, { mail_template: valid_attributes }, valid_session
          expect(assigns(:mail_template)).to be_a(MailTemplate)
          expect(assigns(:mail_template)).to be_persisted
        end

        it 'redirects to the created mail_template' do
          post :create, { mail_template: valid_attributes }, valid_session
          expect(response).to redirect_to(MailTemplate.last)
        end

        describe 'with invalid params' do
          it 'assigns a newly created but unsaved mail_template as @mail_template' do
            post :create, { mail_template: invalid_attributes }, valid_session
            expect(assigns(:mail_template)).to be_a_new(MailTemplate)
          end

          it "re-renders the 'new' template" do
            post :create, { mail_template: invalid_attributes }, valid_session
            expect(response).to render_template('new')
          end
        end
      end
    end

    describe 'PUT update' do
      describe 'with valid params' do
        it 'assigns the requested mail_template as @mail_template' do
          mail_template = MailTemplate.create! valid_attributes
          put :update, { id: mail_template.to_param, mail_template: valid_attributes }, valid_session
          expect(assigns(:mail_template)).to eq(mail_template)
        end

        it 'redirects to the mail_template' do
          mail_template = MailTemplate.create! valid_attributes
          put :update, { id: mail_template.to_param, mail_template: valid_attributes }, valid_session
          expect(response).to redirect_to(mail_template)
        end
      end

      describe 'with invalid params' do
        it 'assigns the mail_template as @mail_template' do
          mail_template = MailTemplate.create! valid_attributes
          put :update, { id: mail_template.to_param, mail_template: invalid_attributes }, valid_session
          expect(assigns(:mail_template)).to eq(mail_template)
        end

        it "re-renders the 'edit' template" do
          mail_template = MailTemplate.create! valid_attributes
          put :update, { id: mail_template.to_param, mail_template: invalid_attributes }, valid_session
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE destroy' do
      it 'destroys the requested mail_template' do
        mail_template = MailTemplate.create! valid_attributes
        expect do
          delete :destroy, { id: mail_template.to_param }, valid_session
        end.to change(MailTemplate, :count).by(-1)
      end

      it 'redirects to the mail_templates list' do
        mail_template = MailTemplate.create! valid_attributes
        delete :destroy, { id: mail_template.to_param }, valid_session
        expect(response).to redirect_to(mail_templates_url)
      end
    end
  end
end
