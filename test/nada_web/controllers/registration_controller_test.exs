defmodule NadaWeb.RegistrationControllerTest do
  use NadaWeb.ConnCase
  alias Nada.{User,Mapping}

  test "GET /register", %{conn: conn} do
    conn = get(conn, Routes.registration_path(conn, :new))
    assert html_response(conn, 200) =~ "Create an account"
  end

  test "POST /register", %{conn: conn} do
    file = %Plug.Upload{path: "test/fixtures/face.jpg", filename: "face.jpg"}
    conn = post(conn, Routes.registration_path(conn, :create), %{
      "user" => %{
        "email" => "bob@example.com",
        "file" => file,
      }
    })
    assert redirected_to(conn, 302) =~ "/register"

    users = Mapping.get()
    refute Enum.empty?(users)

    user = users |> List.first
    assert user.token
    assert user.face_id
    assert user.registration_confidence
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
    assert get_session(conn, :authenticated) == true
    refute Mapping.find_by_email(bob.email).token
  end

  test "GET /register/complete/:token with an invalid token", %{conn: conn} do
    bob = User.new(%{"email" => "bob@example.com"})
    Mapping.add(bob)

    conn = get(conn, Routes.registration_path(conn, :complete, "poop-token"))
    assert redirected_to(conn, 302) =~ "/"
    assert get_session(conn, :authenticated) == nil
  end
end
