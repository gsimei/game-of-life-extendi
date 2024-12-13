require 'rails_helper'

##
# Test suite for the GameState model.
#
# This test suite validates the GameState model's associations and custom validations,
# specifically the validation of `input_file` to ensure it accepts only `.txt` files.
#
# @example Run this test suite with:
#   bundle exec rspec spec/models/game_state_spec.rb
RSpec.describe GameState, type: :model do
  ##
  # Factory setup for a User instance to associate with the GameState model.
  #
  # @return [User] A user object used as the association for GameState.
  let(:user) { create(:user) }

  ##
  # Test suite for validating associations.
  #
  # Ensures that the GameState model correctly belongs to a User.
  describe "associations" do
    ##
    # Validates that GameState has a `belongs_to` association with User.
    #
    # @example Test output:
    #   game_state.user => user instance
    it "belongs to a user" do
      game_state = build(:game_state, user: user)
      expect(game_state.user).to eq(user)
    end
  end

  ##
  # Test suite for custom validations in the GameState model.
  #
  # Focuses on validating that the `input_file` attribute:
  # - Rejects invalid files (non-.txt files)
  # - Accepts valid files (only .txt files)
  describe "validations" do
    ##
    # Validates that the `input_file` attribute rejects invalid files.
    #
    # @example Test output:
    #   game_state.valid? => false
    it "adds an error message when input_file is not a .txt file" do
      invalid_file = fixture_file_upload('spec/fixtures/files/invalid_file.pdf', 'application/pdf')
      game_state = build(:game_state, user: user, input_file: invalid_file)

      expect(game_state).not_to be_valid
      expect(game_state.errors[:input_file]).to include("must be a .txt file")
    end

    ##
    # Validates that the `input_file` attribute accepts valid files.
    #
    # @example Test output:
    #   game_state.valid? => true
    it "does not add an error message when input_file is a .txt file" do
      valid_file = fixture_file_upload('spec/fixtures/files/valid_file.txt', 'text/plain')
      game_state = build(:game_state, user: user, input_file: valid_file)

      game_state.valid? # Trigger validations

      expect(game_state.errors[:input_file]).to be_empty
    end
  end
end
