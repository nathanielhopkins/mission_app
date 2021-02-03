require 'rails_helper'

RSpec.describe UsersController, type: :controller do

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

    it 'renders the show template' do
      user = FactoryBot.create(:user)
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

  describe 'GET #edit' do

  it "returns a successful response" do
    get :edit, params: {id: FactoryBot.create(:user)}
    expect(response).to be_successful
  end
    
  it "renders edit template" do
    get :edit, params: {id: FactoryBot.create(:user)}
    expect(response).to render_template("edit")
  end
end

  describe 'PUT #update' do
    before :each do
      @user = FactoryBot.create(:user)
    end

    context "with invalid params" do

      it "renders the edit template" do
        put :update, params: { id: @user, user: { username: ''}}
        expect(response).to render_template('edit')
      end

      it "validates the presence of the user's username and password" do
        put :update, params: { id: @user, user: { username: ''}}
        expect(response).to render_template('edit')
        expect(flash[:errors]).to be_present
      end

      it "validates that the password is at least 6 characters long" do
        put :update, params: { id: @user, user: { password: 'buns'}}
        expect(response).to render_template('edit')
        expect(flash[:errors]).to eq(["Password is too short (minimum is 6 characters)"])
      end

      it "does not change @user's attributes" do
        put :update, params: { id: @user, user: FactoryBot.attributes_for(:user, username: "bob50", password: "bob") }
        @user.reload
        expect(@user.username).to eq("bob49")
        expect(@user.password).to_not eq("bob50")
      end
    end

    context "with valid params" do
      it "changes @user's attributes" do
        put :update, params: { id: @user, user: FactoryBot.attributes_for(:user, username: "bob50", password: "bobpassword") }
        @user.reload
        expect(@user.username).to eq("bob50")
      end

      it "redirects to the updated user" do
        put :update, params: { id: @user, user: FactoryBot.attributes_for(:user) }
        expect(response).to redirect_to @contact
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @user = FactoryBot.create(:user)
    end

    it "deletes the user" do
      expect{
        delete :destroy, params: { id: @user }
      }.to change(User,:count).by(-1)
    end

    it "redirects to users#index" do
      delete :destroy, params: { id: @user }
      expect(response).to redirect_to users_url
    end
  end
end
