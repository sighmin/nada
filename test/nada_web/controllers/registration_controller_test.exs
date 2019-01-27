defmodule NadaWeb.RegistrationControllerTest do
  use NadaWeb.ConnCase
  alias Nada.{User, Mapping}

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
    resp = html_response(conn, 200)
    assert resp =~ "confirm your email"
  end

  test "GET /register/complete/:token with a valid token", %{conn: conn} do
    bob = User.new(%{"email" => "bob@example.com"})
    Mapping.add(bob)

    conn = get(conn, Routes.registration_path(conn, :complete, bob.token))
    assert html_response(conn, 200) =~ "completed your account"
  end
end
