require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
  subject(:bob49) { FactoryBot.create(:user) } 
  let(:other_user) { FactoryBot.create(:user, username: 'imposter')}
    
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
        it 'redirects to created Goal show page' do
          post :create, params: { goal: { title: 'test goal', details: 'this is only a test'}}
          expect(response).to redirect_to(goal_url(Goal.last))
        end
      end

      context 'with invalid params' do
        it 'validates the presence of title' do
          post :create, params: { goal: { title: '' } }
          expect(response).to render_template('new')
          expect(flash[:errors]).to be_present
        end

        it 'validates the title is at least 6 characters' do
          post :create, params: { goal: { title: 'test' } }
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

  describe 'GET #index' do
    context 'when logged out' do
      before(:each) do
        allow(controller).to receive(:current_user) { nil }
      end

      it 'redirects to the login page' do
        post :create, params: { goal: {} }
        expect(response).to redirect_to(new_user_url)
      end
    end

    context 'when logged in' do
      before(:each) do
        allow(controller).to receive(:current_user) { bob49 }
      end

      it 'renders index template' do
        get :index
        expect(response).to render_template("index")
      end
    end
  end

  describe 'GET #show' do
    context 'when logged out' do
      before(:each) do
        allow(controller).to receive(:current_user) { nil }
      end

      it 'redirects to the login page' do
        post :create, params: { goal: {} }
        expect(response).to redirect_to(new_user_url)
      end
    end

    context 'when logged in' do
      before(:each) do
        allow(controller).to receive(:current_user) { bob49 }
      end
      
      it 'renders the show template' do
        goal = Goal.create(user_id: user.id, title: 'test goal')
        get :show, params: { id: goal.id }
        expect(response).to render_template("show")
      end

      context 'goal does not exist' do
        it 'is not a success' do
          begin
            get :show, params: { id: -1 }
          rescue
            ActiveRecord::RecordNotFound
          end 

          expect(response).not_to render_template(:show)
        end
      end
    end
  end

  describe 'GET #edit' do
    context 'when logged out' do
      before(:each) do
        allow(controller).to receive(:current_user) { nil }
      end

      it 'redirects to the login page' do
        get :edit, params: { id: 1 }
        expect(response).to redirect_to(new_user_url)
      end
    end

    context 'when logged in' do
      before(:each) do
        allow(controller).to receive(:current_user) { bob49 }
        @goal = Goal.create(user_id: bob49.id, title: 'test goal', details: 'this is only a test')
      end

      context 'goal belongs_to current_user' do
        it 'returns a successful response' do
          get :edit, params: { id: @goal.id }
          expect(response).to be_successful
        end

        it 'renders edit template' do
          get :edit, params: { id: @goal.id }
          expect(response).to render_template("edit")
        end
      end

      context 'goal does not belong to current_user' do
        it 'redirects to goal show page' do
          allow(controller).to receieve(:current_user) { other_user }
          get :edit, params: { id: @goal.id }
          expect(response).to redirect_to(goal_url(@goal))
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'when logged out' do
      before(:each) do
        allow(controller).to receive(:current_user) { nil }
      end

      it 'redirects to the login page' do
        post :create, params: { goal: {} }
        expect(response).to redirect_to(new_user_url)
      end
    end

    context 'when logged in' do
      before(:each) do
        allow(controller).to receive(:current_user) { bob49 }
        @goal = Goal.create(user_id: current_user.id, title: 'test goal', details: 'this is just a test.')
      end

      context 'with invalid params' do
        it 'renders the edit template' do
          put :update, params: { id: @goal.id, goal: { title: ''}}
          expect(response).to render_template("edit")
        end

        it 'validates the presence of title' do
          put :update, params: { id: @goal.id, goal: { title: ''}}
          expect(response).to render_template('edit')
          expect(flash[:errors]).to be_present 
        end

        it 'validates title is at least 6 characters' do
          put :update, params: { id: @goal.id, goal: { title: 'test'}}
          expect(response).to render_template('edit')
          expect(flash[:errors]).to eq(["Title is too short (minimum is 6 characters)"])
        end
      end

      context 'with valid params' do
        it 'changes the goal attributes' do
          put :update, params: { id: @goal.id, goal: { details: "the test seems to work"}}
          expect(@goal.details).to eq("the test seems to work")    
        end

        it 'redirects to goal show page' do
          put :update, params: { id: @goal.id, goal: { details: "the test seems to work"}}
          expect(response).to redirect_to(goal_url(@goal))
        end
      end

      context 'goal does not belong to user' do
        it 'does not update attributes' do
          allow(controller).to receive(:current_user) { other_user }
          put :update, params: { id: @goal.id, goal: { details: "the test seems to work"}}
          expect(@goal.details).not_to eq("the test seems to work")
        end

        it 'redirects to goal show page' do
          allow(controller).to receive(:current_user) { other_user }
          put :update, params: { id: @goal.id, goal: { details: "the test seems to work"}}
          expect(response).to redirect_to(goal_url(@goal))
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when logged out' do
      before(:each) do
        allow(controller).to receive(:current_user) { nil }
        @goal = Goal.create(user_id: bob49.id, title: 'test goal')
      end

      it 'redirects to the login page' do
        post :create, params: { id: @goal.id }
        expect(response).to redirect_to(new_user_url)
      end
    end

    context 'when logged in' do
      before(:each) do
        allow(controller).to receive(:current_user) { bob49 }
        @goal = Goal.create(user_id: bob49.id, title: 'test goal')
      end

      it 'deletes the goal' do
        expect{
          delete :destroy, params: { id: @goal.id }
        }.to change(Goal,:count).by(-1)
      end

      it 'redirects to current_user show page' do
        delete :destroy, params: { id: @goal.id }
        expect(response).to redirect_to(user_url(bob49))
      end
    end

    context 'goal does not belong to current_user' do
      it 'does not delete the goal' do
        allow(controller).to receive(:current_user) { other_user }
        expect{
          delete :destroy, params: { id: @goal.id }
        }.to_not change(Goal,:count).by(-1)
      end

      it 'redirects to current_user show page' do
        allow(controller).to receive(:current_user) { other_user }
        delete :destroy, params: { id: @goal.id }
        expect(response).to redirect_to(user_url(other_user))
      end
    end
  end
end
