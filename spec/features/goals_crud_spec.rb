require 'rails_helper'

#TO DO:
# - Write FactoryBot for goals
# - Write in support/goal_features_helper.rb:
    #  - #build_three_goals
    #  - #verify_three_goals
# - Write out scenario specs
# - Write Views to pass specs

feature "Create, Read, Update, Destroy Goals" do
    given!(:user) { FactoryBot.create(:user) }
    
    background(:each) do
        login_test_user
    end
    
    feature "creating goals" do
        scenario "should have a page for creating a new goal"
        
        scenario "should show the new goal after creation"
    end
    
    feature "reading goals" do
        scenario "should list goals"
    end
    
    feature "updating goals" do
        # given(:goal) { FactoryBot.create(:goal, user: user) }
        #write FactoryBot for goal

        scenario "should have a page for updating existing goals"

        scenario "should show the updated goal after changes are saved"
    end

    feature "deleting goals" do
        scenario "should allow the deletion of a goal"
    end
end