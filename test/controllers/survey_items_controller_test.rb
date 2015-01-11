require 'test_helper'

class SurveyItemsControllerTest < ActionController::TestCase
  setup do
    @survey_item = survey_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:survey_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create survey_item" do
    assert_difference('SurveyItem.count') do
      post :create, survey_item: { description: @survey_item.description, headline: @survey_item.headline, survey_id: @survey_item.survey_id, thumbnail_url: @survey_item.thumbnail_url }
    end

    assert_redirected_to survey_item_path(assigns(:survey_item))
  end

  test "should show survey_item" do
    get :show, id: @survey_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @survey_item
    assert_response :success
  end

  test "should update survey_item" do
    patch :update, id: @survey_item, survey_item: { description: @survey_item.description, headline: @survey_item.headline, survey_id: @survey_item.survey_id, thumbnail_url: @survey_item.thumbnail_url }
    assert_redirected_to survey_item_path(assigns(:survey_item))
  end

  test "should destroy survey_item" do
    assert_difference('SurveyItem.count', -1) do
      delete :destroy, id: @survey_item
    end

    assert_redirected_to survey_items_path
  end
end
