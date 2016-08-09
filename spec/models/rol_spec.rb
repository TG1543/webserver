require 'spec_helper'

RSpec.describe Rol, type: :model do
    before { @rol = FactoryGirl.build(:rol) }
    subject { @rol }

    it { should respond_to(:rol) }
    it { should have_many(:users) }
end
