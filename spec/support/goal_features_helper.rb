module GoalFeaturesHelper
  def submit_new_goal(goal_title, privacy = {private: false})
    visit new_goal_url
    fill_in "title", with: goal_title
    if privacy[:private]
      check "private?"
    end
    click_button "Add Goal"
  end

  def build_three_goals(user)
    FactoryBot.create(:goal, title: "omnis quia rerum", user: user)
    FactoryBot.create(:goal, title: "magni voluptates accusantium", user: user)
    FactoryBot.create(:goal, title: "quae recusandae voluptatum", user: user)
  end

  def verify_three_goals
    visit goals_url
    expect(page).to have_content "omnis quia rerum"
    expect(page).to have_content "magni voluptates accusantium"
    expect(page).to have_content "quae recusandae voluptatum"
  end
end