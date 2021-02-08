require 'rails_helper'

RSpec.describe GoalCommentsController, type: :controller do
  subject(:bob49) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, username: 'other_user') }
  let(:goal) { FactoryBot.create(:goal, author: other_user)}

  describe "POST #create" do
    context 'when logged in' do
      before(:each) do
        allow(controller).to receive(:current_user) { bob49 }
      end

      context 'with valid params' do
        it 'saves and displays new comment' do
          post :create, params: { comment: {goal_id: goal.id, body: 'magical comment'}}
          expect(flash[:notices]).to be_present
        end
      end

      context 'with invalid params' do
        it 'validates the presence of body' do
          post :create, params: { comment: { goal_id: goal.id, body: ''}}
          expect(flash[:errors]).to be_present
        end
      end
    end

    context 'when logged out' do
      before(:each) do
        allow(controller).to receive(:current_user) { nil }
      end

      it 'redirects to the login page' do
        post :create, params:  { comment: {goal_id: goal.id, body: 'magical comment'}}
        expect(response).to redirect_to(new_user_url)
      end
    end
  end
end
