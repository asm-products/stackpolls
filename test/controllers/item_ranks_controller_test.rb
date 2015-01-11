require 'test_helper'

class ItemRanksControllerTest < ActionController::TestCase
  setup do
    @item_rank = item_ranks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:item_ranks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create item_rank" do
    assert_difference('ItemRank.count') do
      post :create, item_rank: { rank: @item_rank.rank, response_id: @item_rank.response_id, survey_item_id: @item_rank.survey_item_id }
    end

    assert_redirected_to item_rank_path(assigns(:item_rank))
  end

  test "should show item_rank" do
    get :show, id: @item_rank
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @item_rank
    assert_response :success
  end

  test "should update item_rank" do
    patch :update, id: @item_rank, item_rank: { rank: @item_rank.rank, response_id: @item_rank.response_id, survey_item_id: @item_rank.survey_item_id }
    assert_redirected_to item_rank_path(assigns(:item_rank))
  end

  test "should destroy item_rank" do
    assert_difference('ItemRank.count', -1) do
      delete :destroy, id: @item_rank
    end

    assert_redirected_to item_ranks_path
  end
end
