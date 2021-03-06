require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do

  subject(:user) { User.create!(username: 'bob49', password: 'bobpassword') }
  let(:g1) { Goal.create(user_id: user.id, title: 'Goal user.id', completed: true) }
  let(:g2) { Goal.create(user_id: user.id, title: 'Goal 2', completed: true) }
  let(:g3) { Goal.create(user_id: user.id, title: 'Goal 3', completed: true) }
  let(:g4) { Goal.create(user_id: user.id, title: 'Goal 4') }
  let(:g5) { Goal.create(user_id: user.id, title: 'Goal 5') }

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_length_of(:password).is_at_least(6).on(:create) }
  end

  describe 'associations' do
    it { should have_many(:goals) }
  end

  describe '#is_password?' do
    context 'password is valid' do
      it 'should return true' do
        expect(user.is_password?('bobpassword')).to eq(true)
      end
    end

    context 'password is invalid' do
      it 'should return false' do
        expect(user.is_password?('password')).to eq(false)
      end
    end
  end

  describe '#reset_session_token!' do
    it 'should set a new session token for User' do
      user.session_token = 'garbage'
      user.save
      new_token = user.reset_session_token!
      expect(user.session_token).to eq(new_token)
    end
  end

  describe '::find_by_credentials' do
    before(:each) do
      user.valid?
    end

    context 'user does not exist' do
      it 'should return nil' do
        expect(User.find_by_credentials('billybob', 'biscuits')).to eq(nil)
      end
    end

    context 'user exists' do
      context 'password is correct' do
        it 'should return user' do
          expect(User.find_by_credentials('bob49','bobpassword')).to eq(user)
        end
      end

      context 'password is incorrect' do
        it 'should return nil' do
          expect(User.find_by_credentials('bob49', 'password')).to eq(nil)
        end
      end
    end
  end

  describe '#completed_goals' do

    it "returns all of users goals where completed = true" do
      cg = user.completed_goals
      expect(cg).to include(g1, g2, g3)
    end
    it "does not return goals where completed = false" do
      cg = user.completed_goals
      expect(cg).not_to include(g4)
    end
  end

  describe '#uncompleted_goals' do

    it "returns all of users goals where completed = false" do
      ug = user.uncompleted_goals
      expect(ug).to include(g4, g5)
    end

    it "does not return goals where completed = false" do
      ug = user.uncompleted_goals
      expect(ug).not_to include(g1)
    end
  end
end
