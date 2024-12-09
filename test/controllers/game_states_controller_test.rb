require "test_helper"

class GameStatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_state = game_states(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get game_states_index_url
    assert_response :success
  end

  test "should get show" do
    get game_states_show_url
    assert_response :success
  end
end
