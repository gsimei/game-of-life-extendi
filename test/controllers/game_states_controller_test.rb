require "test_helper"

class GameStatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user

    @game_state = game_states(:one)
  end

  test "should get index" do
    get game_states_url
    assert_response :success
  end

  test "should get show" do
    get game_state_url(@game_state)
    assert_response :success
  end
end
