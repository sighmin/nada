defmodule NadaWeb.SessionControllerTest do
  use NadaWeb.ConnCase
  alias Nada.{User,Mapping}

  test "GET /login", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :new))
    assert html_response(conn, 200) =~ "take a selfie"
  end

  test "POST /login/email", %{conn: conn} do
    file = %Plug.Upload{path: "test/fixtures/face.jpg", filename: "face.jpg"}
    bob = User.new(%{
      "email" => "bob@example.com",
      "file" => file,
    })
    Mapping.add(bob)
    assert bob == Mapping.find_by_file(file)

    user_params = %{
      "user" => %{
        "file" => file
      }
    }

    conn = post(conn, Routes.session_path(conn, :autocomplete_email), user_params)
    assert redirected_to(conn, 302) =~ Routes.session_path(conn, :email_found)
  end

  test "GET /login/email", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :email_found))
    assert html_response(conn, 200) =~ "We found you!"
  end

  @tag :skip
  test "POST /login", %{conn: _conn} do
  end

  test "GET /login/confirm", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :confirm))
    assert html_response(conn, 200) =~ "sent you a magic link"
  end

  test "GET /logout", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :destroy))
    assert redirected_to(conn, 302) =~ "/"

    refute get_session(conn, :authenticated)
  end

  test "GET /logout?redirect_path=/login", %{conn: conn} do
    redirect_path = "/login"
    conn = get(conn, Routes.session_path(conn, :destroy, redirect_path: redirect_path))
    assert redirected_to(conn, 302) =~ redirect_path

    refute get_session(conn, :authenticated)
  end

  test "GET /login/face", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :face_id))
    assert html_response(conn, 200) =~ "looking you up from your face"
  end
end
