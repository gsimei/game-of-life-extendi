require 'rails_helper'

RSpec.describe GameState, type: :model do
  let(:user) { create(:user) }

  describe "associations" do
    it "belongs to a user" do
      game_state = build(:game_state, user: user)
      expect(game_state.user).to eq(user)
    end
  end

  describe "validations" do
    context "when input_file is not a .txt file" do
      it "adds an error message" do
        invalid_file = fixture_file_upload('spec/fixtures/files/invalid_file.pdf', 'application/pdf')
        game_state = build(:game_state, user: user, input_file: invalid_file)

        expect(game_state).not_to be_valid
        expect(game_state.errors[:input_file]).to include("must be a .txt file")
      end
    end

    context "when input_file is a .txt file" do
      it "does not add an error message" do
        valid_file = fixture_file_upload('spec/fixtures/files/valid_file.txt', 'text/plain')
        game_state = build(:game_state, user: user, input_file: valid_file)

        game_state.valid? # Trigger validations

        expect(game_state.errors[:input_file]).to be_empty
      end
    end
  end
end
