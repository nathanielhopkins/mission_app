require 'rails_helper'

feature "privacy of goals" do
  given!(:user) { FactoryBot.create(:user) }
  given!(:other_user) { FactoryBot.create(:user, username: 'other_user') }

  describe 'public goals' do
    given!(:goal) { FactoryBot.create(:goal, user: user) }

    scenario "should create goals as public by default"

    scenario "allows other users to see public goals"
  end

  describe "private goals" do
    given!(:private_goal) { FactoryBot.create(:goal, user: user, private: true) }

    scenario "allows creation of private goals"

    scenario "hides private goals when logged out"

    scenario "hides private goals from other users"
  end  
end 