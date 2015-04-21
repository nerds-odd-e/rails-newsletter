require 'rails_helper'

module Newsletter
  RSpec.describe MailTemplatesController, :type => :controller do
    routes { Engine.routes }

    let(:valid_attributes) {
      FactoryGirl.build(:mail_template).attributes
    }

    let(:invalid_attributes) {
      FactoryGirl.build(:mail_template, subject:nil).attributes
    }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # MailTemplatesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all mail_templates as @mail_templates" do
        mail_template = MailTemplate.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:mail_templates)).to eq([mail_template])
      end
    end

    describe "GET index" do
      let(:mail_template) {MailTemplate.create! valid_attributes.merge({tag_list:"tag1, tag2"})}
      before {mail_template}
      it "filters the tag" do
        get :tag, {tag_id:"abc"}, valid_session
        expect(assigns(:mail_templates)).to eq([])
      end

      it "show mail_template with the tag" do
        get :tag, {tag_id:"tag2"}, valid_session
        expect(assigns(:mail_templates)).to eq([mail_template])
      end
    end

    describe "GET show" do
      it "assigns the requested mail_template as @mail_template" do
        mail_template = MailTemplate.create! valid_attributes
        get :show, {:id => mail_template.to_param}, valid_session
        expect(assigns(:mail_template)).to eq(mail_template)
      end
    end

    describe "GET new" do
      it "assigns a new mail_template as @mail_template" do
        get :new, {}, valid_session
        expect(assigns(:mail_template)).to be_a_new(MailTemplate)
        expect(response).to render_template(layout:"newsletter/mail_templates")
      end
    end

    describe "GET edit" do
      it "assigns the requested mail_template as @mail_template" do
        mail_template = MailTemplate.create! valid_attributes
        get :edit, {:id => mail_template.to_param}, valid_session
        expect(assigns(:mail_template)).to eq(mail_template)
      end
    end

    describe "POST create" do
      describe "with valid params" do

        it "creates a new MailTemplate" do
          expect {
            post :create, {:mail_template => valid_attributes}, valid_session
          }.to change(MailTemplate, :count).by(1)
        end

        it "add tags to the mail_template" do
          post :create, {:mail_template => valid_attributes.merge({tag_list:"a b,c"})}, valid_session
          expect(assigns(:mail_template).tag_list).to eq ["a b", "c"]
        end

        it "assigns a newly created mail_template as @mail_template" do
          post :create, {:mail_template => valid_attributes}, valid_session
          expect(assigns(:mail_template)).to be_a(MailTemplate)
          expect(assigns(:mail_template)).to be_persisted
        end

        it "redirects to the created mail_template" do
          post :create, {:mail_template => valid_attributes}, valid_session
          expect(response).to redirect_to(MailTemplate.last)
        end

        describe "with invalid params" do
          it "assigns a newly created but unsaved mail_template as @mail_template" do
            post :create, {:mail_template => invalid_attributes}, valid_session
            expect(assigns(:mail_template)).to be_a_new(MailTemplate)
          end

          it "re-renders the 'new' template" do
            post :create, {:mail_template => invalid_attributes}, valid_session
            expect(response).to render_template("new")
          end
        end
      end

    end
    describe "POST create to preview" do
      before { allow(controller).to receive(:user) {double(email:"a@b.com")}}
      it "will not create record if preview" do
        expect {
          post :create, {:mail_template => valid_attributes, preview:true}, valid_session
        }.to change(MailTemplate, :count).by(0)
      end

      it "will keep the form if preview" do
        post :create, {:mail_template => valid_attributes, preview:true}, valid_session
        expect(response).to render_template("new")
        expect(assigns(:mail_template).attributes).to eq valid_attributes
      end

      it "will send a email to me" do
        mail = double
        allow(NewsMailer).to receive(:news_mail) {mail}
        expect(mail).to receive(:deliver_now)
        post :create, {:mail_template => valid_attributes, preview:true}, valid_session
        expect(flash[:notice]).to eq "Preview email has been sent. Please check your mailbox."
      end

      it "will not send a email to me if mail_template is not valid" do
        expect(NewsMailer).not_to receive(:news_mail)
        post :create, {:mail_template => invalid_attributes, preview:true}, valid_session
      end

    end

    describe "POST create to send to groups" do
      it "will send a email to nobody" do
        post :create, {:mail_template => valid_attributes.merge({groups:[""]}), send_groups:true}, valid_session
        expect(flash[:notice]).to include "0 emails sent."
      end


      it "will send email to selected groups" do
        user = double
        mail = double
        expect(mail).to receive(:deliver_now).once
        allow(::Newsletter.user_class).to receive(:group).with("users") {[user]}
        allow(NewsMailer).to receive(:news_mail) {mail}
        post :create, {:mail_template => valid_attributes.merge({groups:["users", ""]}), send_groups:true}, valid_session
        expect(flash[:notice]).to include "1 emails sent."
      end

      it "will pause 10 sec for every 10 users" do
        user = double
        mail = double
        allow(mail).to receive(:deliver_now)
        allow(::Newsletter.user_class).to receive(:group).with("users") {[user] * 11}
        expect(NewsMailer).to receive(:news_mail).exactly(11).times {mail}
        post :create, {:mail_template => valid_attributes.merge({groups:["users", ""]}), send_groups:true}, valid_session
        expect(flash[:notice]).to include "11 emails sent."
      end

    end

    describe "PUT update" do
      describe "with valid params" do

        it "assigns the requested mail_template as @mail_template" do
          mail_template = MailTemplate.create! valid_attributes
          put :update, {:id => mail_template.to_param, :mail_template => valid_attributes}, valid_session
          expect(assigns(:mail_template)).to eq(mail_template)
        end

        it "redirects to the mail_template" do
          mail_template = MailTemplate.create! valid_attributes
          put :update, {:id => mail_template.to_param, :mail_template => valid_attributes}, valid_session
          expect(response).to redirect_to(mail_template)
        end

        it "will keep the form if preview" do
          mail_template = MailTemplate.create! valid_attributes
          put :update, {:id => mail_template.to_param, :mail_template => valid_attributes, preview:true}, valid_session
          expect(response).to render_template("new")
        end

      end

      describe "with invalid params" do
        it "assigns the mail_template as @mail_template" do
          mail_template = MailTemplate.create! valid_attributes
          put :update, {:id => mail_template.to_param, :mail_template => invalid_attributes}, valid_session
          expect(assigns(:mail_template)).to eq(mail_template)
        end

        it "re-renders the 'edit' template" do
          mail_template = MailTemplate.create! valid_attributes
          put :update, {:id => mail_template.to_param, :mail_template => invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested mail_template" do
        mail_template = MailTemplate.create! valid_attributes
        expect {
          delete :destroy, {:id => mail_template.to_param}, valid_session
        }.to change(MailTemplate, :count).by(-1)
      end

      it "redirects to the mail_templates list" do
        mail_template = MailTemplate.create! valid_attributes
        delete :destroy, {:id => mail_template.to_param}, valid_session
        expect(response).to redirect_to(mail_templates_url)
      end
    end
  end
end
