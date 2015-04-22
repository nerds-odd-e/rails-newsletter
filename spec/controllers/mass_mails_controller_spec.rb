require 'rails_helper'

module Newsletter
  RSpec.describe MassMailsController, :type => :controller do
    routes { Engine.routes }

    let(:valid_attributes) {
      {subject:"aaa", body:"body"}
    }

    let(:invalid_attributes) {
      {subject:nil}
    }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # MailTemplatesController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET new" do
      it "assigns a new mass_mail as @mass_mail" do
        get :new, {}, valid_session
        expect(assigns(:mass_mail)).to be_a_new(MassMail)
        expect(response).to render_template(layout:"newsletter/mail_templates")
      end
    end

    describe "POST create" do
      describe "with valid params" do

        it "assigns a newly created mass_mail as @mass_mail" do
          post :create, {:mass_mail => valid_attributes}, valid_session
          expect(assigns(:mass_mail)).to be_a(MassMail)
          expect(assigns(:mass_mail)).not_to be_persisted
        end

        it "redirects to the created mass_mail" do
          post :create, {:mass_mail => valid_attributes}, valid_session
          expect(response).to redirect_to(MassMail.last)
        end

        describe "with invalid params" do
          it "assigns a newly created but unsaved mass_mail as @mass_mail" do
            post :create, {:mass_mail => invalid_attributes}, valid_session
            expect(assigns(:mass_mail)).to be_a_new(MassMail)
          end

          it "re-renders the 'new' template" do
            post :create, {:mass_mail => invalid_attributes}, valid_session
            expect(response).to render_template("new")
          end
        end
      end

    end
    describe "POST create to preview" do
      before { allow(controller).to receive(:user) {double(email:"a@b.com")}}
      it "will not create record if preview" do
        expect {
          post :create, {:mass_mail => valid_attributes, preview:true}, valid_session
        }.to change(MassMail, :count).by(0)
      end

#      it "will keep the form if preview" do
        #post :create, {:mass_mail => valid_attributes, preview:true}, valid_session
        ##expect(response).to render_template("new")
        #expect(assigns(:mass_mail).attributes).to eq valid_attributes
      #end

      it "will send a email to me" do
        mail = double
        allow(NewsMailer).to receive(:news_mail) {mail}
        expect(mail).to receive(:deliver_now)
        post :create, {:mass_mail => valid_attributes, preview:true}, valid_session
        expect(flash[:notice]).to eq "Preview email has been sent. Please check your mailbox."
      end

      it "will not send a email to me if mass_mail is not valid" do
        expect(NewsMailer).not_to receive(:news_mail)
        post :create, {:mass_mail => invalid_attributes, preview:true}, valid_session
      end

    end

    describe "POST create to send to groups" do
      it "will send a email to nobody" do
        post :create, {:mass_mail => valid_attributes.merge({groups:[""]}), send_groups:true}, valid_session
        expect(flash[:notice]).to include "0 emails sent."
      end


      it "will send email to selected groups" do
        user = double
        mail = double
        expect(mail).to receive(:deliver_now).once
        allow(::Newsletter.user_class).to receive(:group).with("users") {[user]}
        allow(NewsMailer).to receive(:news_mail) {mail}
        post :create, {:mass_mail => valid_attributes.merge({groups:["users", ""]}), send_groups:true}, valid_session
        expect(flash[:notice]).to include "1 emails sent."
      end

    end

  end
end

