require 'rails_helper'

RSpec.describe UserComment, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:author_id)}
    it { should validate_presence_of(:user_id)}
    it { should validate_presence_of(:body)}
  end

  describe 'associations' do
    it { should belong_to(:author)}
    it { should belong_to(:user)}
  end
end
