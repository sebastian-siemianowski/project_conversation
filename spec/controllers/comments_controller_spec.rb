require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: 'admin') }
  let(:project) { create(:project, user: user) }
  let(:comment) { create(:comment, user: user, project: project) }

  before { sign_in(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new comment' do
        expect {
          post :create, params: { project_id: project.id, comment: { content: 'A new comment' } }
        }.to change(Comment, :count).by(1)
      end

      it 'redirects to the project with a success notice' do
        post :create, params: { project_id: project.id, comment: { content: 'A new comment' } }
        expect(response).to redirect_to(project)
        expect(flash[:notice]).to eq('Comment was successfully added.')
      end

      it 'responds with turbo stream' do
        post :create, params: { project_id: project.id, comment: { content: 'A new comment' }, format: :turbo_stream }
        expect(response.content_type).to include('text/vnd.turbo-stream.html')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new comment' do
        expect {
          post :create, params: { project_id: project.id, comment: { content: '' } }
        }.not_to change(Comment, :count)
      end

      it 'redirects to the project with an alert' do
        post :create, params: { project_id: project.id, comment: { content: '' } }
        expect(response).to redirect_to(project)
        expect(flash[:alert]).to eq('Failed to add comment.')
      end

      it 'responds with turbo stream for errors' do
        post :create, params: { project_id: project.id, comment: { content: '' }, format: :turbo_stream }
        expect(response.content_type).to include('text/vnd.turbo-stream.html')
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested comment to @comment' do
      get :edit, params: { project_id: project.id, id: comment.id }
      expect(assigns(:comment)).to eq(comment)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the comment' do
        patch :update, params: { project_id: project.id, id: comment.id, comment: { content: 'Updated content' } }
        comment.reload
        expect(comment.content).to eq('Updated content')
      end

      it 'redirects to the project with a success notice' do
        patch :update, params: { project_id: project.id, id: comment.id, comment: { content: 'Updated content' } }
        expect(response).to redirect_to(project)
        expect(flash[:notice]).to eq('Comment was successfully updated.')
      end

      it 'responds with turbo stream' do
        patch :update, params: { project_id: project.id, id: comment.id, comment: { content: 'Updated content' }, format: :turbo_stream }
        expect(response.content_type).to include('text/vnd.turbo-stream.html')
      end
    end

    context 'with invalid attributes' do
      it 'does not update the comment' do
        patch :update, params: { project_id: project.id, id: comment.id, comment: { content: '' } }
        comment.reload
        expect(comment.content).not_to eq('')
      end

      it 'renders the edit template' do
        patch :update, params: { project_id: project.id, id: comment.id, comment: { content: '' } }
        expect(response).to render_template(:edit)
      end

      it 'responds with turbo stream for errors' do
        patch :update, params: { project_id: project.id, id: comment.id, comment: { content: '' }, format: :turbo_stream }
        expect(response.content_type).to include('text/vnd.turbo-stream.html')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { comment } # Create a comment before running the test

    it 'deletes the comment' do
      expect {
        delete :destroy, params: { project_id: project.id, id: comment.id }
      }.to change(Comment, :count).by(-1)
    end

    it 'redirects to the project with a success notice' do
      delete :destroy, params: { project_id: project.id, id: comment.id }
      expect(response).to redirect_to(project)
      expect(flash[:notice]).to eq('Comment was successfully deleted.')
    end

    it 'responds with turbo stream' do
      delete :destroy, params: { project_id: project.id, id: comment.id, format: :turbo_stream }
      expect(response.content_type).to include('text/vnd.turbo-stream.html')
    end
  end

  describe 'authorization' do
    let(:other_user) { create(:user) }
    let(:other_comment) { create(:comment, user: other_user, project: project) }

    it 'prevents non-owners from editing, updating, or deleting comments' do
      get :edit, params: { project_id: project.id, id: other_comment.id }
      expect(response).to redirect_to(project)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')

      patch :update, params: { project_id: project.id, id: other_comment.id, comment: { content: 'New content' } }
      expect(response).to redirect_to(project)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')

      delete :destroy, params: { project_id: project.id, id: other_comment.id }
      expect(response).to redirect_to(project)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end
end
