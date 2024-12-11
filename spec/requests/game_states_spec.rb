require 'rails_helper'

RSpec.describe "GameStates", type: :request do
  let(:user) { create(:user) }
  let!(:game_state) { create(:game_state, user: user) }

  before do
    sign_in(user, scope: :user)
  end

  describe "GET /index" do
    it "returns a list of game states" do
      get game_states_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "displays the details of a game state" do
      get game_state_path(game_state)

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "renders the form for a new game state" do
      get new_game_state_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    context "with valid input file" do
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

  describe "PATCH /next_generation" do
    it "progresses the game state to the next generation" do
      allow_any_instance_of(GameState).to receive(:next_generation!).and_call_original

      patch next_generation_game_state_path(game_state)

      expect(response).to redirect_to(game_state_path(game_state))
      follow_redirect!
      expect(response.body).to include("Game State progressed to generation")
    end
  end

  describe "PATCH /reset_to_initial" do
    context "when reset is successful" do
      it "resets the game state and redirects" do
        allow_any_instance_of(GameState).to receive(:restore_initial_state!).and_return(true)

        patch reset_to_initial_game_state_path(game_state)

        expect(response).to redirect_to(game_state_path(game_state))
        follow_redirect!
        expect(response.body).to include("Game state has been reset to its initial version.")
      end
    end

    context "when reset fails" do
      it "shows an error message" do
        allow_any_instance_of(GameState).to receive(:restore_initial_state!).and_return(false)

        patch reset_to_initial_game_state_path(game_state)

        expect(response).to redirect_to(game_state_path(game_state))
        follow_redirect!
        expect(response.body).to include("Failed to reset game state.")
      end
    end
  end

  describe "DELETE /destroy" do
    it "deletes the game state and redirects to index" do
      expect {
        delete game_state_path(game_state)
      }.to change(GameState, :count).by(-1)

      expect(response).to redirect_to(game_states_path)
    end
  end
end
