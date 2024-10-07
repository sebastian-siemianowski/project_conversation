require 'rails_helper'

RSpec.describe StatusChange, type: :model do
  # Association Tests
  it { should belong_to(:project) }
  it { should belong_to(:user) }
end
