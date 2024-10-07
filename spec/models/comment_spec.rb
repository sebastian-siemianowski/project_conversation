require 'rails_helper'

RSpec.describe Comment, type: :model do
  # Association Tests
  it { should belong_to(:user) }
  it { should belong_to(:project) }

  # Validation Tests
  it { should validate_presence_of(:content) }

  # Factory or Instance Tests
  describe 'comment creation' do
    let(:user) { create(:user) }
    let(:project) { create(:project, user: user) }

    it 'is valid with valid attributes' do
      comment = Comment.new(content: 'This is a comment', user: user, project: project)
      expect(comment).to be_valid
    end

    it 'is invalid without content' do
      comment = Comment.new(content: '', user: user, project: project)
      expect(comment).to_not be_valid
      expect(comment.errors[:content]).to include("can't be blank")
    end
  end
end
