require 'rails_helper'

module Newsletter
  RSpec.describe NewslettersController, :type => :controller do
    routes { Engine.routes }

    let(:valid_attributes) {
      FactoryGirl.build(:newsletter).attributes
    }

    let(:invalid_attributes) {
      FactoryGirl.build(:newsletter, subject:nil).attributes
    }

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # NewslettersController. Be sure to keep this updated too.
    let(:valid_session) { {} }

    describe "GET index" do
      it "assigns all newsletters as @newsletters" do
        newsletter = Newsletter.create! valid_attributes
        get :index, {}, valid_session
        expect(assigns(:newsletters)).to eq([newsletter])
      end
    end

    describe "GET index" do
      let(:newsletter) {Newsletter.create! valid_attributes.merge({tag_list:"tag1, tag2"})}
      before {newsletter}
      it "filters the tag" do
        get :tag, {tag_id:"abc"}, valid_session
        expect(assigns(:newsletters)).to eq([])
      end

      it "show newsletter with the tag" do
        get :tag, {tag_id:"tag2"}, valid_session
        expect(assigns(:newsletters)).to eq([newsletter])
      end
    end

    describe "GET show" do
      it "assigns the requested newsletter as @newsletter" do
        newsletter = Newsletter.create! valid_attributes
        get :show, {:id => newsletter.to_param}, valid_session
        expect(assigns(:newsletter)).to eq(newsletter)
      end
    end

    describe "GET new" do
      it "assigns a new newsletter as @newsletter" do
        get :new, {}, valid_session
        expect(assigns(:newsletter)).to be_a_new(Newsletter)
        expect(response).to render_template(layout:"newsletter/newsletters")
      end
    end

    describe "GET edit" do
      it "assigns the requested newsletter as @newsletter" do
        newsletter = Newsletter.create! valid_attributes
        get :edit, {:id => newsletter.to_param}, valid_session
        expect(assigns(:newsletter)).to eq(newsletter)
      end
    end

    describe "POST create" do
      describe "with valid params" do

        it "creates a new Newsletter" do
          expect {
            post :create, {:newsletter => valid_attributes}, valid_session
          }.to change(Newsletter, :count).by(1)
        end

        it "add tags to the newsletter" do
          post :create, {:newsletter => valid_attributes.merge({tag_list:"a b,c"})}, valid_session
          expect(assigns(:newsletter).tag_list).to eq ["a b", "c"]
        end

        it "assigns a newly created newsletter as @newsletter" do
          post :create, {:newsletter => valid_attributes}, valid_session
          expect(assigns(:newsletter)).to be_a(Newsletter)
          expect(assigns(:newsletter)).to be_persisted
        end

        it "redirects to the created newsletter" do
          post :create, {:newsletter => valid_attributes}, valid_session
          expect(response).to redirect_to(Newsletter.last)
        end

        describe "with invalid params" do
          it "assigns a newly created but unsaved newsletter as @newsletter" do
            post :create, {:newsletter => invalid_attributes}, valid_session
            expect(assigns(:newsletter)).to be_a_new(Newsletter)
          end

          it "re-renders the 'new' template" do
            post :create, {:newsletter => invalid_attributes}, valid_session
            expect(response).to render_template("new")
          end
        end
      end

    end
    describe "POST create to preview" do
      before { allow(controller).to receive(:user) {double(email:"a@b.com")}}
      it "will not create record if preview" do
        expect {
          post :create, {:newsletter => valid_attributes, preview:true}, valid_session
        }.to change(Newsletter, :count).by(0)
      end

      it "will keep the form if preview" do
        post :create, {:newsletter => valid_attributes, preview:true}, valid_session
        expect(response).to render_template("new")
        expect(assigns(:newsletter).attributes).to eq valid_attributes
      end

      it "will send a email to me" do
        mail = double
        allow(NewsMailer).to receive(:news_mail) {mail}
        expect(mail).to receive(:deliver_now)
        post :create, {:newsletter => valid_attributes, preview:true}, valid_session
        expect(flash[:notice]).to eq "Preview email has been sent. Please check your mailbox."
      end

      it "will not send a email to me if newsletter is not valid" do
        expect(NewsMailer).not_to receive(:news_mail)
        post :create, {:newsletter => invalid_attributes, preview:true}, valid_session
      end

    end

    describe "POST create to send to groups" do
      it "will send a email to nobody" do
        post :create, {:newsletter => valid_attributes.merge({groups:[""]}), send_groups:true}, valid_session
        expect(flash[:notice]).to include "0 emails sent."
      end


      it "will send email to selected groups" do
        user = double
        mail = double
        expect(controller).not_to receive(:sleep)
        expect(mail).to receive(:deliver_now).once
        allow(::Newsletter.user_class).to receive(:group).with("users") {[user]}
        allow(NewsMailer).to receive(:news_mail) {mail}
        post :create, {:newsletter => valid_attributes.merge({groups:["users", ""]}), send_groups:true}, valid_session
        expect(flash[:notice]).to include "1 emails sent."
      end

      it "will pause 10 sec for every 10 users" do
        user = double
        mail = double
        allow(mail).to receive(:deliver_now)
        allow(::Newsletter.user_class).to receive(:group).with("users") {[user] * 11}
        expect(NewsMailer).to receive(:news_mail).exactly(11).times {mail}
        expect(controller).to receive(:sleep).with(10.0)
        post :create, {:newsletter => valid_attributes.merge({groups:["users", ""]}), send_groups:true}, valid_session
        expect(flash[:notice]).to include "11 emails sent."
      end

    end

    describe "PUT update" do
      describe "with valid params" do
        let(:new_attributes) {
          skip("Add a hash of attributes valid for your model")
        }

        it "updates the requested newsletter" do
          newsletter = Newsletter.create! valid_attributes
          put :update, {:id => newsletter.to_param, :newsletter => new_attributes}, valid_session
          newsletter.reload
          skip("Add assertions for updated state")
        end

        it "assigns the requested newsletter as @newsletter" do
          newsletter = Newsletter.create! valid_attributes
          put :update, {:id => newsletter.to_param, :newsletter => valid_attributes}, valid_session
          expect(assigns(:newsletter)).to eq(newsletter)
        end

        it "redirects to the newsletter" do
          newsletter = Newsletter.create! valid_attributes
          put :update, {:id => newsletter.to_param, :newsletter => valid_attributes}, valid_session
          expect(response).to redirect_to(newsletter)
        end

        it "will keep the form if preview" do
          newsletter = Newsletter.create! valid_attributes
          put :update, {:id => newsletter.to_param, :newsletter => valid_attributes, preview:true}, valid_session
          expect(response).to render_template("new")
        end

      end

      describe "with invalid params" do
        it "assigns the newsletter as @newsletter" do
          newsletter = Newsletter.create! valid_attributes
          put :update, {:id => newsletter.to_param, :newsletter => invalid_attributes}, valid_session
          expect(assigns(:newsletter)).to eq(newsletter)
        end

        it "re-renders the 'edit' template" do
          newsletter = Newsletter.create! valid_attributes
          put :update, {:id => newsletter.to_param, :newsletter => invalid_attributes}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested newsletter" do
        newsletter = Newsletter.create! valid_attributes
        expect {
          delete :destroy, {:id => newsletter.to_param}, valid_session
        }.to change(Newsletter, :count).by(-1)
      end

      it "redirects to the newsletters list" do
        newsletter = Newsletter.create! valid_attributes
        delete :destroy, {:id => newsletter.to_param}, valid_session
        expect(response).to redirect_to(newsletters_url)
      end
    end
  end
end
