require 'rails_helper'

feature "Commenting" do
  given!(:user) { FactoryBot.create(:user) }
  given!(:other_user) { FactoryBot.create(:user, username: 'other_user')}
  given!(:goal) { FactoryBot.create(:goal, user_id: other_user.id)}

  background(:each) do
    login_test_user
    visit user_url(other_user)
  end

  shared_examples "comment" do
    scenario "should have a form for adding a new comment" do
      expect(page).to have_content "New Comment"
      expect(page).to have_field "Comment"
    end

    scenario "should save the comment when a user submits one" do
      fill_in "Comment", with: "my magical comment!"
      click_on "Save Comment"
      expect(page).to have_content "my magical comment!"
    end
  end

  feature 'user profile comment' do
    it_behaves_like "comment"
  end

  feature 'goal comment' do
    background(:each) do
      click_on goal.title
    end

    it_behaves_like "comment"
  end
end