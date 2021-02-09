require 'rails_helper'

RSpec.describe Cheer, type: :model do
  describe 'validations' do
    it { should validate_uniqueness_of(:goal_id).scoped_to(:giver_id) }
  end

  describe 'associations' do
    it { should belong_to(:giver) }
    it { should belong_to(:goal) }
  end
end
