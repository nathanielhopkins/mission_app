require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
  subject(:bob49) { FactoryBot.create(:user) } 
    
  describe 'GET #new' do
    context 'when logged in' do
      before(:each) do
        allow(controller).to receive(:current_user) { bob49 }
      end

      it "returns a successful response" do
        get :new
        expect(response).to be_successful
      end

      it "renders the new Goals template" do
        get :new
        expect(response).to render_template("new")
      end
    end

    context 'when logged out' do
      before do
        allow(controller).to receive(:current_user) { nil }
      end

      it 'redirects to new_user_url' do
        get :new
        expect(response).to redirect_to(new_user_url)
      end
    end
  end

  describe 'POST #create' do
    context 'when logged in' do
      before(:each) do
        allow(controller).to receive(:current_user) { bob49 }
      end

      context 'with valid params' do
        it 'returns a successful response' do
          post :create, params: { goal: { title: 'test', details: 'this is only a test'}}
          expect(response).to be_successful
        end

        it 'redirects to created Goal show page' do
          post :create, params: { goal: { title: 'test', details: 'this is only a test'}}
          expect(response).to redirect_to(goal_url(Goal.last))
        end
      end

      context 'with invalid params' do
        it 'validates the presence of title and url' do
          post :create, params: { goal: { title: 'invld' } }
          expect(response).to render_template('new')
          expect(flash[:errors]).to be_present
        end
      end
    end

    context 'when logged out' do
      before(:each) do
        allow(controller).to receive(:current_user) { nil }
      end

      it 'redirects to the login page' do
        post :create, params: { goal: {} }
        expect(response).to redirect_to(new_user_url)
      end
    end
  end
end
