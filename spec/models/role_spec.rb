require 'spec_helper'

RSpec.describe Role, type: :model do
    before { @role = FactoryGirl.build(:role) }
    subject { @role }

    it { should respond_to(:value) }
    it { should have_many(:users) }
end
