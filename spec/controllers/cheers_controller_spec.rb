require 'rails_helper'

RSpec.describe CheersController, type: :controller do
  let(:bob49) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, username: 'other_user') }
  let(:goal) { Goal.create(user_id: other_user.id, title: 'test goal') }

  describe "GET #index" do
    context "when logged in" do
      before :each do
        allow(controller).to receive(:current_user) { bob49 }
      end
        
      it "returns a successful response" do
        get :index, {}
        expect(response).to be_successful
      end
        
      it 'renders the index template' do
        get :index
        expect(response).to render_template("index")
      end  
    end
    context "when logged out" do
      before :each do
        allow(controller).to receive(:current_user) { nil }
      end

      it "redirects to login page" do
        get :index
        expect(response).to redirect_to(new_user_url)
      end
    end
  end

  describe "POST #create" do
    context "when logged in" do
      before :each do
        allow(controller).to receive(:current_user) { bob49 }
      end

      context "with valid params" do
        context "user has cheers remaining" do
          it "increments cheers" do
            post :create, params: { cheer: { goal_id: goal.id} }
            expect(flash[:notices]).to be_present
          end
        end

        context "user has no cheers remaining" do
          it "does not increment cheers and raises error" do
            current_user.cheers = 0
            current_user.save
            post :create, params: { cheer: { goal_id: goal.id} }
            expect(flash[:errors]).to be_present
          end
        end
      end

      context "with invalid params" do
        it "does not increment cheers" do
          post :create, params: { cheer: { goal_id: nil} }
          expect(flash[:errors]).to be_present
        end
      end
    end

    context "when logged out" do
      before :each do
        allow(controller).to receive(:current_user) { nil }
      end

      it "redirects to login page" do
        post :create
        expect(reponse).to redirect_to(new_user_url)
      end
    end
  end
end
