require 'rails_helper'

RSpec.describe Cheer, type: :model do
  let(:user) { User.create!(username: 'bob49', password: 'bobpassword') }
  let(:g1) { Goal.create!(user_id: user.id, title: 'Goal user.id', completed: true) }
  subject(:cheer) { Cheer.create!(giver_id: user.id, goal_id: g1.id)}
  
  describe 'validations' do
    it { should validate_uniqueness_of(:goal_id).scoped_to(:giver_id) }
  end

  describe 'associations' do
    it { should belong_to(:giver) }
    it { should belong_to(:goal) }
  end
end
