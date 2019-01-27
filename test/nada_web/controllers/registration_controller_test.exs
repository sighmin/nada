defmodule NadaWeb.SessionControllerTest do
  use NadaWeb.ConnCase

  test "GET /login", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :new))
    assert html_response(conn, 200) =~ "take a selfie"
  end

  test "GET /login/face", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :face_id))
    assert html_response(conn, 200) =~ "looking you up from your face"
  end

  test "GET /login/email", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :email_found))
    assert html_response(conn, 200) =~ "We found you!"
  end

  test "GET /login/confirm", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :confirm))
    assert html_response(conn, 200) =~ "sent you a magic link"
  end
end
