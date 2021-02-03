require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
  let(:bob49) { FactoryBot.create(:user) } 
    
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
    end

    context 'when logged out' do
    end
  end
end
