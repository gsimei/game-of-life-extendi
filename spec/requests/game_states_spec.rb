require 'rails_helper'
require 'warden/jwt_auth'

##
# Testes para API::V1::GameStates
#
# Essa suíte de testes valida as requisições para o controlador `GameStatesController`,
# garantindo que todas as operações (index, show, create, next_generation, reset_to_initial e destroy)
# funcionem corretamente para a API.
#
# @example Executar os testes com:
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
  # Teste para a ação GET /api/v1/game_states
  #
  # Verifica se a API retorna uma lista de game states do usuário autenticado.
  #
  # @example Resposta esperada:
  #   response.status => 200
  #   response.body => [{ "id": 1, "user_id": 1, "created_at": "..." }]
  #
  describe "GET /api/v1/game_states" do
    it "retorna uma lista de game states" do
      get api_v1_game_states_path, headers: headers

      expect(response).to have_http_status(:success)
      expect(response.parsed_body).to be_an(Array)
    end
  end

  ##
  # Teste para a ação GET /api/v1/game_states/:id
  #
  # Verifica se a API retorna corretamente os detalhes de um game state específico.
  #
  # @example Resposta esperada:
  #   response.status => 200
  #   response.body => { "id": 1, "user_id": 1, "created_at": "..." }
  #
  describe "GET /api/v1/game_states/:id" do
    it "retorna os detalhes de um game state" do
      get api_v1_game_state_path(game_state), headers: headers

      expect(response).to have_http_status(:success)
      expect(response.parsed_body["id"]).to eq(game_state.id)
    end
  end

  ##
  # Teste para a ação POST /api/v1/game_states
  #
  # Verifica se a API permite a criação de um novo game state.
  #
  # @example Resposta esperada:
  #   response.status => 201
  #   response.body => { "id": 2, "user_id": 1, "created_at": "..." }
  #
  describe "POST /api/v1/game_states" do
    let(:valid_file) { fixture_file_upload('spec/fixtures/files/valid_file.txt', 'text/plain') }

    it "cria um novo game state" do
      expect {
        post api_v1_game_states_path, params: { game_state: { input_file: valid_file } }, headers: headers
      }.to change(GameState, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.parsed_body["id"]).to be_present
    end
  end

  ##
  # Teste para a ação PATCH /api/v1/game_states/:id/next_generation
  #
  # Verifica se a API avança o game state para a próxima geração.
  #
  # @example Resposta esperada:
  #   response.status => 200
  #   response.body => { "id": 1, "generation": 2 }
  #
  describe "PATCH /api/v1/game_states/:id/next_generation" do
    it "avança o game state para a próxima geração" do
      allow_any_instance_of(GameState).to receive(:next_generation!).and_return(true)

      patch next_generation_api_v1_game_state_path(game_state), headers: headers

      expect(response).to have_http_status(:success)
      expect(response.parsed_body["id"]).to eq(game_state.id)
    end
  end

  ##
  # Teste para a ação PATCH /api/v1/game_states/:id/reset_to_initial
  #
  # Verifica se a API permite restaurar um game state para seu estado inicial.
  #
  # @example Resposta esperada:
  #   response.status => 200
  #   response.body => { "id": 1, "generation": 0 }
  #
  describe "PATCH /api/v1/game_states/:id/reset_to_initial" do
    context "quando o reset é bem-sucedido" do
      it "restaura o game state para o estado inicial" do
        allow_any_instance_of(GameState).to receive(:restore_initial_state!).and_return(true)

        patch reset_to_initial_api_v1_game_state_path(game_state), headers: headers

        expect(response).to have_http_status(:success)
        expect(response.parsed_body["id"]).to eq(game_state.id)
      end
    end

    context "quando o reset falha" do
      it "retorna uma mensagem de erro" do
        allow_any_instance_of(GameState).to receive(:restore_initial_state!).and_return(false)

        patch reset_to_initial_api_v1_game_state_path(game_state), headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body).to include("errors")
      end
    end
  end

  ##
  # Teste para a ação DELETE /api/v1/game_states/:id
  #
  # Verifica se a API permite excluir um game state.
  #
  # @example Resposta esperada:
  #   response.status => 204 (No Content)
  #
  describe "DELETE /api/v1/game_states/:id" do
    it "exclui o game state" do
      expect {
        delete api_v1_game_state_path(game_state), headers: headers
      }.to change(GameState, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
