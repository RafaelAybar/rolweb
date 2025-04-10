require "application_system_test_case"

class CuentosTest < ApplicationSystemTestCase
  setup do
    @cuento = cuentos(:one)
  end

  test "visiting the index" do
    visit cuentos_url
    assert_selector "h1", text: "Cuentos"
  end

  test "should create cuento" do
    visit cuentos_url
    click_on "New cuento"

    fill_in "Nombre", with: @cuento.nombre
    check "Spoilers" if @cuento.spoilers
    click_on "Create Cuento"

    assert_text "Cuento was successfully created"
    click_on "Back"
  end

  test "should update Cuento" do
    visit cuento_url(@cuento)
    click_on "Edit this cuento", match: :first

    fill_in "Nombre", with: @cuento.nombre
    check "Spoilers" if @cuento.spoilers
    click_on "Update Cuento"

    assert_text "Cuento was successfully updated"
    click_on "Back"
  end

  test "should destroy Cuento" do
    visit cuento_url(@cuento)
    click_on "Destroy this cuento", match: :first

    assert_text "Cuento was successfully destroyed"
  end
end
