require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    context "with valid attributes" do
      let(:user) { build(:user) }

      it "is valid" do
        expect(user).to be_valid
      end
    end
  end
end
