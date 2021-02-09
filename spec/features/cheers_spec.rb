require 'rails_helper'

feature "giving cheers" do
  given!(:user) { FactoryBot.create(:user) }
  given!(:other_user) { FactoryBot.create(:user, username: "other_user") }

  given!(:user_goal) { FactoryBot.create(:goal, user: user) }
  given!(:other_user_goal) { FactoryBot.create(:goal, user: other_user) }

  background(:each) do
    login_other_user
  end

  scenario "lets a user give a cheer for another user's goal" do
    give_cheer_to(user)
    expect(page).to have_content("You cheered bob49's goal!")
    expect(page).not_to have_button "Cheer!"
  end

  scenario "does not let a user cheer their own goals" do
    visit goal_url(other_user_goal)
    expect(page).not_to have_button "Cheer!"
    visit user_url(other_user)
    expect(page).not_to have_button "Cheer!"
  end

  scenario "does not let the user cheer the same goal twice" do
    give_cheer_to(user)
    expect(page).not_to have_button "Cheer!"
  end
end

feature "viewing my cheers" do
  given!(:user) { FactoryBot.create(:user) }
  given!(:other_user) { FactoryBot.create(:user, username: "other_user") }
  given!(:user_goal) { FactoryBot.create(:goal, user: user) }

  background(:each) do
    FactoryBot.create(:cheer, giver: other_user, goal: user_goal)
    login_test_user
  end

  scenario "lets a user see the number of cheers given for their goal" do
    visit goal_url(user_goal)
    expect(page).to have_content "Cheers: 1"
  end

  scenario "has a cheer index that shows the cheers with their info" do
    visit cheers_url
    expect(page).to have_content "Cheer given by:"
    expect(page).to have_content other_user.username
    expect(page).to have_content "For goal of:"
    expect(page).to have_content user_goal.title
  end
end