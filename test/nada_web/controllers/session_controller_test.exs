defmodule NadaWeb.RegistrationControllerTest do
  use NadaWeb.ConnCase

  test "GET /register", %{conn: conn} do
    conn = get(conn, Routes.registration_path(conn, :new))
    assert html_response(conn, 200) =~ "Create an account"
  end

  test "POST /register", %{conn: conn} do
    conn = post(conn, Routes.registration_path(conn, :create), %{
      "user" => %{
        "email" => "bob@example.com",
        "file" => nil,
      }
    })
    assert html_response(conn, 302) =~ "redirected"
  end

  test "GET /register/confirm", %{conn: conn} do
    conn = get(conn, Routes.registration_path(conn, :confirm))
    assert html_response(conn, 200) =~ "confirm your email"
  end

  test "GET /register/complete", %{conn: conn} do
    conn = get(conn, Routes.registration_path(conn, :complete))
    assert html_response(conn, 200) =~ "completed your account"
  end
end
