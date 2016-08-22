require 'spec_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do
  describe "GET #show" do
    before(:each) do
      user = FactoryGirl.create :user
      @project = FactoryGirl.create :project
      api_authorization_header user.auth_token
      get :show, {user_id: user.id,id: @project.id}
    end

    it "returns the information about a reporter on a hash" do
      product_response = json_response
      expect(product_response[:name]).to eql @project.name
    end

    it { should respond_with 200 }
  end

  describe "GET #index" do
    before(:each) do
      user = FactoryGirl.create :user
      4.times { FactoryGirl.create :project }
      api_authorization_header user.auth_token
      get :index
    end

    it "returns 4 records from the database" do
      projects_response = json_response
      expect(projects_response.size).to eql 4
    end

    it { should respond_with 200 }
  end


  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        state = FactoryGirl.create :state
        @project_attributes = FactoryGirl.attributes_for :project
        @project_attributes[:state_id] = state.id
        api_authorization_header user.auth_token
        post :create, project: @project_attributes
      end

      it "renders the json representation for the product record just created" do
        project_response = json_response
        expect(project_response[:name]).to eql @project_attributes[:name]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_project_attributes = { name: "", description: "description" }
        api_authorization_header user.auth_token
        post :create, project: @invalid_project_attributes
      end

      it "renders an errors json" do
        project_response = json_response
        expect(project_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        project_response = json_response
        expect(project_response[:errors][:name]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @state = FactoryGirl.create :state
      @project = FactoryGirl.create :project, user: @user, state: @state
      api_authorization_header @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @project.id,
              project: { name: "project" } }
      end

      it "renders the json representation for the updated user" do
        project_response = json_response
        expect(project_response[:name]).to eql "project"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @project.id,
              project: { name: "" } }
      end

      it "renders an errors json" do
        project_response = json_response
        expect(project_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        project_response = json_response
        expect(project_response[:errors][:name]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

end
