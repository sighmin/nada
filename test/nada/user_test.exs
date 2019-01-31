defmodule Nada.UserTest do
  use ExUnit.Case
  alias Nada.User

  test "new generates a user from params" do
    params = %{ "email" => "bob@email.com" }
    user = User.new(params)
    assert params["email"], user.email
    assert user.token
  end

  test "new formats user's file" do
    params = %{
      "email" => "bob@email.com",
      "file" => %Plug.Upload{
        path: "test/fixtures/face.jpg",
        filename: "face.jpg"
      }
    }
    user = User.new(params)
    assert params["email"], user.email

    expected_file_map = %{
      file_id: "pkbohv-face.jpg",
      file_name: "face.jpg",
    }
    assert expected_file_map.file_name == user.file.file_name
    assert expected_file_map.file_id =~ user.file.file_name
  end

  test "generate_otp sets a new otp" do
    bob = User.new(%{ "email" => "bob@email.com" })
    refute bob.otp
    bob = User.generate_otp(bob)
    assert bob.otp
  end

  test "clear tokens removes otp and token" do
    bob = User.new(%{ "email" => "bob@email.com" })
    bob = User.generate_otp(bob)
    assert bob.token
    assert bob.otp

    bob = User.clear_tokens(bob)
    refute bob.token
    refute bob.otp
  end
end
