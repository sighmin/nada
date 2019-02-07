defmodule NadaWeb.SessionControllerTest do
  use NadaWeb.ConnCase
  alias Nada.{User,Mapping}

  test "GET /login", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :new))
    assert html_response(conn, 200) =~ "take a selfie"
  end

  test "POST /login/email", %{conn: conn} do
    file = %Plug.Upload{path: "test/fixtures/face.jpg", filename: "face.jpg"}
    face_id = "abc123"
    email = "bob@example.com"
    bob = User.new(%{
      "email" => email,
      "file" => file,
      "face_id" => face_id,
    })
    Mapping.add(bob)
    assert bob == Mapping.find_by_face_id(face_id)

    user_params = %{
      "user" => %{
        "file" => file
      }
    }

    conn = post(conn, Routes.session_path(conn, :autocomplete_email), user_params)
    assert redirected_to(conn, 302) =~ Routes.session_path(conn, :email_found)
    user = Mapping.get() |> List.first
    assert face_id == user.face_id
    assert email == user.email
  end

  test "GET /login/email", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :email_found))
    assert html_response(conn, 200) =~ "We can&#39;t find you"
  end

  test "POST /login", %{conn: conn} do
    bob = User.new(%{
      "email" => "bob@example.com",
      "file" => %Plug.Upload{
        path: "test/fixtures/face.jpg",
        filename: "face.jpg",
      },
    })
    Mapping.add(bob)
    user_params = %{
      "user" => %{
        "email" => bob.email
      }
    }

    conn = post(conn, Routes.session_path(conn, :create), user_params)
    assert redirected_to(conn, 302) =~ Routes.session_path(conn, :confirm)
  end

  test "GET /login/confirm", %{conn: conn} do
    conn = get(conn, Routes.session_path(conn, :confirm))
    assert html_response(conn, 200) =~ "sent you a magic link"
  end

  test "GET /login/complete/:otp with a valid otp", %{conn: conn} do
    bob = User.new(%{"email" => "bob@example.com"}) |> User.generate_otp()
    Mapping.add(bob)

    conn = get(conn, Routes.session_path(conn, :complete, bob.otp))
    assert redirected_to(conn, 302) =~ "/nothing"
    assert get_session(conn, :authenticated) == true
    refute Mapping.find_by_email(bob.email).otp
  end

  test "GET /login/complete/:otp with an invalid otp", %{conn: conn} do
    bob = User.new(%{"email" => "bob@example.com"}) |> User.generate_otp()
    Mapping.add(bob)

    conn = get(conn, Routes.session_path(conn, :complete, "poop-otp"))
    assert redirected_to(conn, 302) =~ "/"
    assert get_session(conn, :authenticated) == nil
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
end
