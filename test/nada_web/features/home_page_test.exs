defmodule NadaWeb.HomePageTest do
  use NadaWeb.FeatureCase, async: true

  test "visiting the home page", %{session: session} do
    session
    |> visit("/")
    |> assert_has(css(".title", text: "nada"))
  end
end
