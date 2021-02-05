require 'rails_helper'

feature "goal completeness tracking" do
  given!(:user) { FactoryBot.create(:user) }
  given!(:other_user) { FactoryBot.create(:user, username: 'other_user')}
  given!(:goal) { FactoryBot.create(:goal, user: user)}

  background(:each) do
    login_test_user
  end

  describe "goals start as uncompleted" do
    context "on the goal show page" do
      scenario "starts as not completed" do
        visit goal_url(goal)
        expect(page).to have_content("Ongoing")
      end
    end

    context "on the goal index page" do
      scenario "starts as not completed" do
        visit goals_url
        expect(page).to have_content("Ongoing")
      end
    end

    context "on the user's profile page" do
      scenario "starts as not completed" do
        visit user_url(user)
        expect(page).to have_content("Ongoing")
      end
    end
  end

  describe "marking a goal as completed"
    context "on the goal show page" do
      scenario "allows user to change goals to completed" do
        visit goal_url(goal)
        click_button "goal_#{goal.id}_completed"
        expect(page).to have_content("Complete")
      end

      scenario "redirects to the same show page after updating goal" do
        visit goal_url(goal)
        click_button "goal_#{goal.id}_completed"
        expect(page).to have_content("Goal:")
        expect(page).to have_content("Title:")
        expect(page).to have_content(goal.title)
      end

      scenario "disallows editing completeness when it's not your goal" do
        click_button "Logout"
        login_other_user
        visit goal_url(goal)
        expect(page).not_to have_button("Complete")
      end
    end

    context "on the goal index page" do
      scenario "allows user to change goals to completed" do
        visit goals_url
        click_button "goal_#{goal.id}_completed"
        expect(page).to have_content("Complete")
      end

      scenario "redirects to the same page after updating goal" do
        visit goals_url
        click_button "goal_#{goal.id}_completed"
        expect(page).to have_content("Your Goals")
      end
    end

    context "on the user's show page" do
      scenario "allows user to change goals to completed" do
        visit user_url(user)
        click_button "goal_#{goal.id}_completed"
        expect(page).to have_content("Complete")
      end

      scenario "redirects to the same page after updating goal" do
        visit user_url(user)
        click_button "goal_#{goal.id}_completed"
        expect(page).to have_content("Complete")
        expect(page).to have_content("bob49's Profile")
        expect(page).to have_content("bob49's Goals:")
      end

      scenario "disallows editing completeness when it's not your goal" do
        click_button "Logout"
        login_other_user
        visit user_url(user)
        expect(page).not_to have_content("Complete")
      end
    end

end