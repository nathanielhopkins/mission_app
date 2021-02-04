require 'rails_helper'

feature "Create, Read, Update, Destroy Goals" do
    given!(:user) { FactoryBot.create(:user) }
    
    background(:each) do
        login_test_user
    end
    
    feature "creating goals" do
        scenario "should have a page for creating a new goal" do
            visit new_goal_url
            expect(page).to have_content "New Goal"
        end
        
        scenario "should show the new goal after creation" do
            submit_new_goal("simple test goal")
            expect(page).to have_content "simple test goal"
            expect(page).to have_content "Goal saved!"
        end
    end
    
    feature "reading goals" do
        scenario "should list goals" do
            build_three_goals(user)
            verify_three_goals
        end
    end
    
    feature "updating goals" do
        given!(:goal) { FactoryBot.create(:goal, user: user) }

        scenario "should have a page for updating existing goals" do
            visit edit_goal_url(goal)
            expect(page).to have_content "Edit Goal"
            expec(find_field('title').value).to eq(goal.title)
        end

        scenario "should show the updated goal after changes are saved" do
            visit edit_goal_url(goal)
            fill_in 'title', with: 'updated test goal'
            click_button 'Update Goal'
            expect(page).not_to have_content "Edit Goal"
            expect(page).to have_content "Goal updated!"
            expect(page).to have_content "updated test goal"
        end
    end

    feature "deleting goals" do
        scenario "should allow the deletion of a goal" do
            build_three_goals(user)
            visit goals_url
            click_button "delete 'omnis quia rerum' goal"
            expect(page).not_to have_content "omnis quia rerum"
            expect(page).to have_content "Goal deleted!"
        end
    end
end