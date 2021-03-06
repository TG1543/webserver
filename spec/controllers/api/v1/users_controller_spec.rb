require 'spec_helper'

describe Api::V1::UsersController do
  before(:each) do
    request.headers['Accept'] = "application/json, #{Mime::JSON}"
    request.headers['Content-Type'] = Mime::JSON.to_s
  end

  describe "GET #index" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header  @user.auth_token
      4.times { FactoryGirl.create :user }
      get :index, format: :json
    end

    it "returns the information about all users" do
      user_response = json_response
      expect(user_response.size).to eql 5
    end

    it "returns 200" do
       should respond_with 200
    end

  end

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header  @user.auth_token
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it "returns 200" do
       should respond_with 200
    end

  end

  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        role = FactoryGirl.create :role
        @user_attributes[:role_id] = role.id
        post :create, { user: @user_attributes }, format: :json
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        #notice I'm not including the email
        @invalid_user_attributes = { password: "12345678",
                                     password_confirmation: "12345678" }
        post :create, { user: @invalid_user_attributes }, format: :json
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header  @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        #@user = FactoryGirl.create :user
        patch :update, { id: @user.id, user: { email: "newmail@example.com",name: "Nombre1" } }, format: :json
      end

      it "renders the json representation for the updated user" do
        user_response = json_response
        expect(user_response[:email]).to eql "newmail@example.com"
        expect(user_response[:name]).to eql "Nombre1"
      end

      it { should respond_with 200 }
    end

    context "when is not created" do
      before(:each) do
        #@user = FactoryGirl.create :user
        patch :update, { id: @user.id, user: { email: "bademail.com" } }, format: :json
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
       api_authorization_header @user.auth_token
      delete :destroy, { id: @user.id }, format: :json
    end

    it { should respond_with 204 }

  end


end
