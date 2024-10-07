# spec/controllers/projects_controller_spec.rb
require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:admin) { create(:user, role: 'admin') } # Use the `role` attribute to set the admin role
  let(:project) { create(:project, user: admin, status: 'not_started') }
  let(:valid_attributes) { { title: 'New Project', description: 'Project description', status: 'not_started' } }
  let(:invalid_attributes) { { title: '', description: 'Project description' } }

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it 'assigns @projects and renders the index template' do
      get :index
      expect(assigns(:projects)).to eq(Project.order(created_at: :asc))
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns @project and @comments' do
      get :show, params: { id: project.id }
      expect(assigns(:project)).to eq(project)
      expect(assigns(:comments)).to eq(project.comments.order(created_at: :asc).page(1).per(7))
    end

    it 'renders the show template' do
      get :show, params: { id: project.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new project and renders the new template' do
      get :new
      expect(assigns(:project)).to be_a_new(Project)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new project and redirects to index' do
        expect {
          post :create, params: { project: valid_attributes }
        }.to change(Project, :count).by(1)
        expect(response).to redirect_to(projects_path)
      end

      it 'responds with turbo stream' do
        post :create, params: { project: valid_attributes }, format: :turbo_stream
        expect(response.content_type).to start_with('text/vnd.turbo-stream.html')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new project and renders the new template' do
        post :create, params: { project: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'responds with turbo stream for errors' do
        post :create, params: { project: invalid_attributes }, format: :turbo_stream
        expect(response.content_type).to start_with('text/vnd.turbo-stream.html')
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested project and renders the edit template' do
      get :edit, params: { id: project.id }, format: :turbo_stream
      expect(assigns(:project)).to eq(project)
      expect(response).to render_template('projects/show')
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      let(:new_attributes) { { title: 'Updated Project Title', status: 'in_progress' } }

      it 'updates the project and redirects to show' do
        patch :update, params: { id: project.id, project: new_attributes }
        project.reload
        expect(project.title).to eq('Updated Project Title')
        expect(project.status).to eq('in_progress')
        expect(response).to redirect_to(project)
      end

      it 'responds with turbo stream on successful update' do
        patch :update, params: { id: project.id, project: new_attributes }, format: :turbo_stream
        expect(response.content_type).to start_with('text/vnd.turbo-stream.html')
      end
    end

    context 'with invalid attributes' do
      it 'does not update the project and renders edit' do
        patch :update, params: { id: project.id, project: invalid_attributes }
        expect(response).to render_template(:edit)
      end

      it 'responds with turbo stream for errors' do
        patch :update, params: { id: project.id, project: invalid_attributes }, format: :turbo_stream
        expect(response.content_type).to start_with('text/vnd.turbo-stream.html')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the project and redirects to index' do
      project_to_delete = create(:project, user: admin)
      expect {
        delete :destroy, params: { id: project_to_delete.id }
      }.to change(Project, :count).by(-1)
      expect(response).to redirect_to(projects_path)
    end

    it 'responds with turbo stream on destroy' do
      project_to_delete = create(:project, user: admin)
      delete :destroy, params: { id: project_to_delete.id }, format: :turbo_stream
      expect(response.content_type).to start_with('text/vnd.turbo-stream.html')
    end
  end

  describe 'Authorization' do
    let(:non_admin) { create(:user, role: 'member') }

    before do
      sign_in non_admin
    end

    it 'redirects to projects index with an alert when user is not an admin' do
      get :edit, params: { id: project.id }
      expect(response).to redirect_to(projects_path)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end
end
