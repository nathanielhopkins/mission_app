require 'spec_helper'
require 'rails_helper'

feature 'the signup process' do

  scenario 'has a new user page' do
    visit new_user_url
    expect(page).to have_content("New User")
  end

  feature 'signing up a user' do

    before(:each) do
      visit new_user_url
      fill_in 'username', with: 'testing_username'
      fill_in 'password', with: 'biscuits'
      click_on 'Create User'
    end

    scenario 'shows username on the homepage after signup' do
      expect(page).to have_content "testing_username"
    end
  end
end

feature 'logging in' do
 
  before :each do
    FactoryBot.create(:user) if User.all.empty?
    login_test_user
  end

  scenario 'shows username on the homepage after login' do
    expect(page).to have_content "bob49"
  end

end

feature 'logging out' do
  given!(:user) { FactoryBot.create(:user) }

  scenario 'begins with a logged out state' do
    visit root_url
    expect(page).to have_content "Login"
  end

  scenario 'doesn\'t show username on the homepage after logout' do
    login_test_user
    click_button "Logout"
    expect(page).not_to have_content "bob49"
  end
end