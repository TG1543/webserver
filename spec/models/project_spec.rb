require 'spec_helper'

describe Project do
  let(:project) { FactoryGirl.build :project }
  subject { project }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }
  it { should respond_to(:state_id) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :user_id }

  it { should belong_to :user }
end
