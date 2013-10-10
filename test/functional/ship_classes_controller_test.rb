require 'test_helper'

class ShipClassesControllerTest < ActionController::TestCase
  setup do
    @ship_class = ship_classes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ship_classes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ship_class" do
    assert_difference('ShipClass.count') do
      post :create, ship_class: { name: @ship_class.name }
    end

    assert_redirected_to ship_class_path(assigns(:ship_class))
  end

  test "should show ship_class" do
    get :show, id: @ship_class
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ship_class
    assert_response :success
  end

  test "should update ship_class" do
    put :update, id: @ship_class, ship_class: { name: @ship_class.name }
    assert_redirected_to ship_class_path(assigns(:ship_class))
  end

  test "should destroy ship_class" do
    assert_difference('ShipClass.count', -1) do
      delete :destroy, id: @ship_class
    end

    assert_redirected_to ship_classes_path
  end
end
