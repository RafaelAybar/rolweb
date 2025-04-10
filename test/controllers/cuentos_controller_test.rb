require "test_helper"

class CuentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cuento = cuentos(:one)
  end

  test "should get index" do
    get cuentos_url
    assert_response :success
  end

  test "should get new" do
    get new_cuento_url
    assert_response :success
  end

  test "should create cuento" do
    assert_difference("Cuento.count") do
      post cuentos_url, params: { cuento: { nombre: @cuento.nombre, spoilers: @cuento.spoilers } }
    end

    assert_redirected_to cuento_url(Cuento.last)
  end

  test "should show cuento" do
    get cuento_url(@cuento)
    assert_response :success
  end

  test "should get edit" do
    get edit_cuento_url(@cuento)
    assert_response :success
  end

  test "should update cuento" do
    patch cuento_url(@cuento), params: { cuento: { nombre: @cuento.nombre, spoilers: @cuento.spoilers } }
    assert_redirected_to cuento_url(@cuento)
  end

  test "should destroy cuento" do
    assert_difference("Cuento.count", -1) do
      delete cuento_url(@cuento)
    end

    assert_redirected_to cuentos_url
  end
end
