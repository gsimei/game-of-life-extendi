require 'rails_helper'
require 'warden/jwt_auth'

##
# Tests for API::V1::GameStates
#
# This test suite validates the requests to the `GameStatesController`,
# ensuring that all operations (index, show, create, next_generation, reset_to_initial, and destroy)
# work correctly for the API.
#
# @example Run the tests with:
#   bundle exec rspec spec/requests/api/v1/game_states_spec.rb
#
RSpec.describe "API::V1::GameStates", type: :request do
  let(:user) { create(:user) }
  let!(:game_state) { create(:game_state, user: user) }

  let(:headers) do
    token = Warden::JWTAuth::UserEncoder.new.call(user, :api_v1_user, nil).first
    { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" }
  end

  before do
    allow_any_instance_of(Api::V1::GameStatesController).to receive(:current_api_v1_user).and_return(user)
  end

  ##
  # Test for the GET /api/v1/game_states action
  #
  # Checks if the API returns a list of game states for the authenticated user.
  #
  # @example Expected response:
  #   response.status => 200
  #   response.body => [{ "id": 1, "user_id": 1, "created_at": "..." }]
  #
  describe "GET /api/v1/game_states" do
    it "returns a list of game states" do
      get api_v1_game_states_path, headers: headers

      expect(response).to have_http_status(:success)
      expect(response.parsed_body).to be_an(Array)
    end
  end

  ##
  # Test for the GET /api/v1/game_states/:id action
  #
  # Checks if the API correctly returns the details of a specific game state.
  #
  # @example Expected response:
  #   response.status => 200
  #   response.body => { "id": 1, "user_id": 1, "created_at": "..." }
  #
  describe "GET /api/v1/game_states/:id" do
    it "returns the details of a game state" do
      get api_v1_game_state_path(game_state), headers: headers

      expect(response).to have_http_status(:success)
      expect(response.parsed_body["id"]).to eq(game_state.id)
    end
  end

  ##
  # Test for the POST /api/v1/game_states action
  #
  # Checks if the API allows the creation of a new game state.
  #
  # @example Expected response:
  #   response.status => 201
  #   response.body => { "id": 2, "user_id": 1, "created_at": "..." }
  #
  describe "POST /api/v1/game_states" do
    let(:valid_file) { fixture_file_upload('spec/fixtures/files/valid_file.txt', 'text/plain') }

    it "creates a new game state" do
      expect {
        post api_v1_game_states_path, params: { game_state: { input_file: valid_file } }, headers: headers
      }.to change(GameState, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.parsed_body["id"]).to be_present
    end
  end

  ##
  # Test for the PATCH /api/v1/game_states/:id/next_generation action
  #
  # Checks if the API advances the game state to the next generation.
  #
  # @example Expected response:
  #   response.status => 200
  #   response.body => { "id": 1, "generation": 2 }
  #
  describe "PATCH /api/v1/game_states/:id/next_generation" do
    it "advances the game state to the next generation" do
      allow_any_instance_of(GameState).to receive(:next_generation!).and_return(true)

      patch next_generation_api_v1_game_state_path(game_state), headers: headers

      expect(response).to have_http_status(:success)
      expect(response.parsed_body["id"]).to eq(game_state.id)
    end
  end

  ##
  # Test for the PATCH /api/v1/game_states/:id/reset_to_initial action
  #
  # Checks if the API allows restoring a game state to its initial state.
  #
  # @example Expected response:
  #   response.status => 200
  #   response.body => { "id": 1, "generation": 0 }
  #
  describe "PATCH /api/v1/game_states/:id/reset_to_initial" do
    context "when the reset is successful" do
      it "restores the game state to the initial state" do
        allow_any_instance_of(GameState).to receive(:restore_initial_state!).and_return(true)

        patch reset_to_initial_api_v1_game_state_path(game_state), headers: headers

        expect(response).to have_http_status(:success)
        expect(response.parsed_body["id"]).to eq(game_state.id)
      end
    end

    context "when the reset fails" do
      it "returns an error message" do
        allow_any_instance_of(GameState).to receive(:restore_initial_state!).and_return(false)

        patch reset_to_initial_api_v1_game_state_path(game_state), headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to include("errors")
      end
    end
  end

  ##
  # Test for the DELETE /api/v1/game_states/:id action
  #
  # Checks if the API allows deleting a game state.
  #
  # @example Expected response:
  #   response.status => 204 (No Content)
  #
  describe "DELETE /api/v1/game_states/:id" do
    it "deletes the game state" do
      expect {
        delete api_v1_game_state_path(game_state), headers: headers
      }.to change(GameState, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
