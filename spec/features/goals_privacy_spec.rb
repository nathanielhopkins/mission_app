require 'rails_helper'

feature "privacy of goals" do
  given!(:user) { FactoryBot.create(:user) }
  given!(:other_user) { FactoryBot.create(:user, username: 'other_user') }

  describe 'public goals' do
    given!(:goal) { FactoryBot.create(:goal, user: user) }

    scenario "should create goals as public by default"  do
      login_test_user
      submit_new_goal("climb Mt. Rainier")
      expect(page).to have_content "Public"
    end

    scenario "allows other users to see public goals" do
      login_other_user
      visit user_url(user)
      expect(page).to have_content goal.title
    end
  end

  describe "private goals" do
    given!(:private_goal) { FactoryBot.create(:goal, user: user, private: true) }

    scenario "allows creation of private goals" do
      login_test_user
      visit goal_url(private_goal)
      expect(page).to have_content "Private"
    end

    scenario "hides private goals when logged out" do
      visit user_url(user)
      expect(page).not_to have_content private_goal.title
    end

    scenario "hides private goals from other users" do
      login_other_user
      visit user_url(user)
      expect(page).not_to have_content private_goal.title
    end
  end  
end 