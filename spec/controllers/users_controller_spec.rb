require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  subject(:user) { FactoryBot.create(:user)}
  let(:other_user) { FactoryBot.create(:user, username: "other_user")}

  describe "GET #new" do

    it "returns a successful response" do
      get :new, {}
      expect(response).to be_successful
    end

    it "assigns a new User to @user" do
      @user = User.new
      get :new, {}
      expect(assigns[:user].id).to eq(@user.id)
    end

    it "renders the new template" do
      get :new, {}
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "with invalid params" do
      it "validates the presence of the user's username and password" do
        post :create, params: { user: { username: 'bob49'}}
        expect(response).to render_template('new')
        expect(flash[:errors]).to be_present
      end

      it "validates that the password is at least 6 characters long" do
        post :create, params: { user: { username: 'bob49', password: 'buns'}}
        expect(response).to render_template('new')
        expect(flash[:errors]).to eq(["Password is too short (minimum is 6 characters)"])
      end

      it "renders new template" do
        post :create, params: { user: { username: 'bob49', password: 'buns'}}
        expect(response).to render_template("new")
      end
    end

    context "with valid params" do
      it "redirects user to users index on success" do
        post :create, params: { user: { username: 'bob49', password: 'bobpassword'}}
        expect(response).to redirect_to(user_url(User.last))
      end
    end
  end

  describe 'GET #index' do
    before :each do
      allow(controller).to receive(:current_user) { user }
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

  describe 'GET #show' do
    before :each do
      allow(controller).to receive(:current_user) { user }
    end


    it 'renders the show template' do
      get :show, params: {id: user.id}
      expect(response).to render_template("show")
    end

    context 'if the user does not exist' do
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
