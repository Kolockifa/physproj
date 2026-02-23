defmodule PhysprojWeb.ErrorJSONTest do
  use PhysprojWeb.ConnCase, async: true

  test "renders 404" do
    assert PhysprojWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert PhysprojWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
