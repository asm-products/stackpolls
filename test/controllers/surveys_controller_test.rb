require 'test_helper'

class SurveysControllerTest < ActionController::TestCase
  setup do
    @survey = surveys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:surveys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create survey" do
    assert_difference('Survey.count') do
      post :create, survey: { headline: @survey.headline, invite_required: @survey.invite_required, permalink: @survey.permalink, subheader: @survey.subheader, thanks_continue_url: @survey.thanks_continue_url, thanks_headline: @survey.thanks_headline, thanks_subheader: @survey.thanks_subheader, title: @survey.title, user_id: @survey.user_id }
    end

    assert_redirected_to survey_path(assigns(:survey))
  end

  test "should show survey" do
    get :show, id: @survey
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @survey
    assert_response :success
  end

  test "should update survey" do
    patch :update, id: @survey, survey: { headline: @survey.headline, invite_required: @survey.invite_required, permalink: @survey.permalink, subheader: @survey.subheader, thanks_continue_url: @survey.thanks_continue_url, thanks_headline: @survey.thanks_headline, thanks_subheader: @survey.thanks_subheader, title: @survey.title, user_id: @survey.user_id }
    assert_redirected_to survey_path(assigns(:survey))
  end

  test "should destroy survey" do
    assert_difference('Survey.count', -1) do
      delete :destroy, id: @survey
    end

    assert_redirected_to surveys_path
  end
end
