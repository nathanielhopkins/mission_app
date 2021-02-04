require 'rails_helper'

feature "goal completeness tracking" do
  given!(:user) { FactoryBot.create(:user) }
  given!(:other_user) { FactoryBot.create(:user, username: 'other_user')}

  background(:each) do
    login_test_user
  end

  describe "goals start as uncompleted" do
    context "on the goal show page" do
      scenario "starts as not completed"
    end

    context "on the goal index page" do
      scenario "starts as not completed"
    end

    context "on the user's profile page" do
      scenario "starts as not completed"
    end
  end

  describe "marking a goal as completed"
    context "on the goal show page" do
      scenario "allows user to change goals to completed"

      scenario "redirects to the same show page after updating goal"

      scenario "disallows editing completeness when it's not your goal"
    end

    context "on the goal index page" do
      scenario "allows user to change goals to completed"

      scenario "redirects to the same show page after updating goal"
    end

    context "on the user's show page" do
      scenario "allows user to change goals to completed"

      scenario "redirects to the same show page after updating goal"

      scenario "disallows editing completeness when it's not your goal"
    end

end