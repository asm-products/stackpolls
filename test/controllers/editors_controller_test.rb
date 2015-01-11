require 'test_helper'

class EditorsControllerTest < ActionController::TestCase
  setup do
    @editor = editors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:editors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create editor" do
    assert_difference('Editor.count') do
      post :create, editor: { accepted_at: @editor.accepted_at, email: @editor.email, inviter_id: @editor.inviter_id, survey_id: @editor.survey_id, user_id: @editor.user_id }
    end

    assert_redirected_to editor_path(assigns(:editor))
  end

  test "should show editor" do
    get :show, id: @editor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @editor
    assert_response :success
  end

  test "should update editor" do
    patch :update, id: @editor, editor: { accepted_at: @editor.accepted_at, email: @editor.email, inviter_id: @editor.inviter_id, survey_id: @editor.survey_id, user_id: @editor.user_id }
    assert_redirected_to editor_path(assigns(:editor))
  end

  test "should destroy editor" do
    assert_difference('Editor.count', -1) do
      delete :destroy, id: @editor
    end

    assert_redirected_to editors_path
  end
end
