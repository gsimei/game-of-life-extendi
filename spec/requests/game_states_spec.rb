require 'rails_helper'

##
# Test suite for the GameStates requests.
#
# This test suite validates the various request actions for the GameStates controller,
# including index, show, new, create, next_generation, reset_to_initial, and destroy.
#
# @example Run this test suite with:
#   bundle exec rspec spec/requests/game_states_spec.rb
RSpec.describe "GameStates", type: :request do
  let(:user) { create(:user) }
  let!(:game_state) { create(:game_state, user: user) }

  before do
    sign_in(user, scope: :user)
  end

  ##
  # Test suite for the GET /index action.
  #
  # Ensures that the index action returns a list of game states.
  describe "GET /index" do
    ##
    # Validates that the index action returns a successful response.
    #
    # @example Test output:
    #   response.status => 200
    it "returns a list of game states" do
      get game_states_path

      expect(response).to have_http_status(:success)
    end
  end

  ##
  # Test suite for the GET /show action.
  #
  # Ensures that the show action displays the details of a game state.
  describe "GET /show" do
    ##
    # Validates that the show action returns a successful response.
    #
    # @example Test output:
    #   response.status => 200
    it "displays the details of a game state" do
      get game_state_path(game_state)

      expect(response).to have_http_status(:success)
    end
  end

  ##
  # Test suite for the GET /new action.
  #
  # Ensures that the new action renders the form for a new game state.
  describe "GET /new" do
    ##
    # Validates that the new action returns a successful response.
    #
    # @example Test output:
    #   response.status => 200
    it "renders the form for a new game state" do
      get new_game_state_path

      expect(response).to have_http_status(:success)
    end
  end

  ##
  # Test suite for the POST /create action.
  #
  # Ensures that the create action handles both valid and invalid input files.
  describe "POST /create" do
    context "with valid input file" do
      ##
      # Validates that the create action creates a new game state and redirects.
      #
      # @example Test output:
      #   response.status => 302
      #   response.body => "Game State created successfully!"
      it "creates a new game state and redirects" do
        valid_file = fixture_file_upload('spec/fixtures/files/valid_file.txt', 'text/plain')

        expect {
          post game_states_path, params: { game_state: { input_file: valid_file } }
        }.to change(GameState, :count).by(1)

        expect(response).to redirect_to(game_state_path(GameState.last))
        follow_redirect!
        expect(response.body).to include("Game State created successfully!")
      end
    end

    context "with invalid input file" do
      ##
      # Validates that the create action renders an error message and redirects.
      #
      # @example Test output:
      #   response.status => 302
      #   response.body => "Error saving GameState"
      it "renders an error message and redirects" do
        invalid_file = fixture_file_upload('spec/fixtures/files/invalid_file.pdf', 'application/pdf')

        expect {
          post game_states_path, params: { game_state: { input_file: invalid_file } }
        }.not_to change(GameState, :count)

        expect(response).to redirect_to(new_game_state_path)
        follow_redirect!
        expect(response.body).to include("Error saving GameState")
      end
    end
  end

  ##
  # Test suite for the PATCH /next_generation action.
  #
  # Ensures that the next_generation action progresses the game state to the next generation.
  describe "PATCH /next_generation" do
    ##
    # Validates that the next_generation action progresses the game state and returns a successful response.
    #
    # @example Test output:
    #   response.status => 200
    #   response.body => "Game State progressed to generation"
    it "progresses the game state to the next generation" do
      mocked_game_state = instance_double("GameState")

      allow(GameState).to receive(:find).and_return(mocked_game_state)
      allow(mocked_game_state).to receive(:next_generation!).and_return(true)

      patch next_generation_game_state_path(game_state), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Game State progressed to generation")
    end
  end

  ##
  # Test suite for the PATCH /reset_to_initial action.
  #
  # Ensures that the reset_to_initial action handles both successful and failed resets.
  describe "PATCH /reset_to_initial" do
    context "when reset is successful" do
      ##
      # Validates that the reset_to_initial action resets the game state and returns a successful response.
      #
      # @example Test output:
      #   response.status => 200
      #   response.body => "Game State restored to initial state"
      it "resets the game state and renders turbo stream" do
        allow_any_instance_of(GameState).to receive(:restore_initial_state!).and_return(true)

        patch reset_to_initial_game_state_path(game_state), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Game State restored to initial state")
      end
    end

    context "when reset fails" do
      ##
      # Validates that the reset_to_initial action shows an error message when the reset fails.
      #
      # @example Test output:
      #   response.status => 200
      #   response.body => "Could not restore initial state"
      it "shows an error message" do
        allow_any_instance_of(GameState).to receive(:restore_initial_state!).and_return(false)

        patch reset_to_initial_game_state_path(game_state), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Could not restore initial state")
      end
    end
  end

  ##
  # Test suite for the DELETE /destroy action.
  #
  # Ensures that the destroy action deletes the game state and redirects to the index.
  describe "DELETE /destroy" do
    ##
    # Validates that the destroy action deletes the game state and redirects to the index.
    #
    # @example Test output:
    #   response.status => 302
    it "deletes the game state and redirects to index" do
      expect {
        delete game_state_path(game_state)
      }.to change(GameState, :count).by(-1)

      expect(response).to redirect_to(game_states_path)
    end
  end
end
