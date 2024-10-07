require 'rails_helper'

RSpec.describe User, type: :model do
  # Association Tests
  it { should have_many(:projects) }

  # Enum Tests
  it { should define_enum_for(:role).with_values(member: 0, admin: 1) }

  # Devise Modules Tests
  it { should respond_to(:email) }
  it { should respond_to(:encrypted_password) }
  it { should respond_to(:valid_password?) }

  # Callbacks Tests
  describe 'callbacks' do
    it 'sets default role to member' do
      user = User.new
      expect(user.role).to eq('member')
    end
  end
end
