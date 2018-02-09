require 'test_helper'

class Api::LanguagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_language = api_languages(:one)
  end

  test "should get index" do
    get api_languages_url
    assert_response :success
  end

  test "should get new" do
    get new_api_language_url
    assert_response :success
  end

  test "should create api_language" do
    assert_difference('Api::Language.count') do
      post api_languages_url, params: { api_language: {  } }
    end

    assert_redirected_to api_language_url(Api::Language.last)
  end

  test "should show api_language" do
    get api_language_url(@api_language)
    assert_response :success
  end

  test "should get edit" do
    get edit_api_language_url(@api_language)
    assert_response :success
  end

  test "should update api_language" do
    patch api_language_url(@api_language), params: { api_language: {  } }
    assert_redirected_to api_language_url(@api_language)
  end

  test "should destroy api_language" do
    assert_difference('Api::Language.count', -1) do
      delete api_language_url(@api_language)
    end

    assert_redirected_to api_languages_url
  end
end
