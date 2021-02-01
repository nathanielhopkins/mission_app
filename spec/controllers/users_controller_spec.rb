require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #new" do

    it "returns a successful response" do
      get :new, {}
      expect(response).to be_successful
    end

    it "assings a new User to @user" do
      new_user = User.new
      get :new, {}
      expect(assings[:user]).to eq(new_user)
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

    it 'assings the requested user to @user' do
      user = Factory(:user)
      get :show, id: user
      expect(assings[:user]).to eq(user)  
    end

    it 'renders the show template' do
      get :show, id: Facory(:user)
      expect(response).to render_template("show")
    end
  end

  describe 'GET #edit' do

  it "returns a successful response" do
    get :edit, id: Factory(:user)
    expect(response).to be_successful
  end

  it "assign given user to @user" do
    Factory(:user)
    get :edit, id: Factory(:user)
    expect(assings[:user]).to eq(User.last)
  end
    
  it "renders edit template" do
    get :edit, id: Factory(:user)
    expect(response).to render_template("edit")
  end
end

  describe 'PUT #edit' do
    before :each do
      @user = Factory(:user)
    end

    context "with invalid params" do
      it "locates the requested @user" do
        put :update, id: @user, user: Factory.attributes_for(:user, username: "bob49", password: "bob")
        expect(assings[:user]).to eq(@user)
      end

      it "does not change @user's attributes" do
        put :update, id: @user, user: Factory.attributes_for(:user, username: "bob50", password: "bob")
        @user.reload
        @user.username.should eq("bob49")
        @user.password.should_not eq("bob50")
      end
    end

    context "with valid params" do
      it "locates the requested @user" do
        put :update, id: @user, user: Factory.attributes_for(:user)
        expect(assings[:user]).to eq(@user)
      end
      
      it "changes @user's attributes" do
        put :update, id: @user, user: Factory.attributes_for(:user, username: "bob50", password: "bobpassword")
        @user.reload
        @user.username.should eq("bob50")
      end

      it "redirects to the updated user" do
        put :update, id: @user, user: Factory.attributes_for(:user)
        expect(response).to redirect_to @contact
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @user = Factory(:user)
    end

    it "deletes the user" do
      expect{
        delete :destroy, id: @user        
      }.to change(User,:count).by(-1)
    end

    it "redirects to users#index" do
      delete :destroy, id: @user
      expect(response).to redirect_to users_url
    end
  end
end
