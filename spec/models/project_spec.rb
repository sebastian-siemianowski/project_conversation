require 'rails_helper'

RSpec.describe Project, type: :model do
  # Association Tests
  it { should belong_to(:user) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:status_changes).dependent(:destroy) }

  # Enum Tests
  it { should define_enum_for(:status).with_values({ not_started: 0, in_progress: 1, completed: 2, on_hold: 3 }) }

  # Validation Tests
  it { should validate_presence_of(:title) }

  # Class Method Tests
  describe '.destroy_all' do
    let!(:user) { create(:user) }
    let!(:project) { create(:project, user: user) }

    context 'when in development or test environment' do
      it 'destroys all projects' do
        expect(Project.count).to eq(1)
        Project.destroy_all
        expect(Project.count).to eq(0)
      end
    end

    context 'when in production environment' do
      it 'does not destroy any projects' do
        allow(Rails.env).to receive(:development?).and_return(false)
        allow(Rails.env).to receive(:test?).and_return(false)

        expect(Project.count).to eq(1)
        Project.destroy_all
        expect(Project.count).to eq(1)
      end
    end
  end
end
