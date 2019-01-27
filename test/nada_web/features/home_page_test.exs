defmodule NadaWeb.HomePageTest do
  use NadaWeb.FeatureCase, async: true

  test "visiting the home page", %{session: session} do
    session
    |> visit("/")
    |> assert_has(css(".slogan", text: "login with nothing"))
  end
end
