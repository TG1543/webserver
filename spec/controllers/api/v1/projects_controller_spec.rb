require 'spec_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do
  describe "GET #show" do
    before(:each) do
      @project = FactoryGirl.create :project
      get :show, id: @project.id
    end

    it "returns the information about a reporter on a hash" do
      product_response = json_response
      expect(product_response[:name]).to eql @project.name
    end

    it { should respond_with 200 }
  end

  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :project }
      get :index
    end

    it "returns 4 records from the database" do
      projects_response = json_response
      #print "-------------------------#{projects_response[0]}"
      expect(projects_response.size).to eql 4
    end

    it { should respond_with 200 }
  end


  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @project_attributes = FactoryGirl.attributes_for :project
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, project: @project_attributes }

      end

      it "renders the json representation for the product record just created" do
          #print "11------------>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#{user.email}\n"
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
        post :create, { user_id: user.id, project: @invalid_project_attributes }
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
