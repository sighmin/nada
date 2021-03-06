defmodule Nada.MappingTest do
  use ExUnit.Case
  alias Nada.{Mapping,User}

  setup do
    on_exit &Mapping.flush/0
    :ok
  end

  test "starts with an empty list" do
    list = Mapping.get()
    assert [] == list
  end

  test "add stores items in memory" do
    user = %User{}
    Mapping.add(user)
    list = Mapping.get()
    assert [user] == list
  end

  test "find_by_token returns first matching user" do
    bob = User.new(%{"email" => "bob@example.com"})
    jim = User.new(%{"email" => "jim@example.com"})
    eeb = User.new(%{"email" => "eeb@example.com"})

    assert bob.token()
    assert jim.token()
    assert eeb.token()

    Mapping.add(bob)
    Mapping.add(jim)

    assert nil == Mapping.find_by_token(eeb.token)
    assert bob == Mapping.find_by_token(bob.token)
    assert jim == Mapping.find_by_token(jim.token)
  end

  test "find_by_otp returns first matching user" do
    bob = User.new(%{"email" => "bob@example.com"})
          |> User.generate_otp()
    jim = User.new(%{"email" => "jim@example.com"})
          |> User.generate_otp()
    eeb = User.new(%{"email" => "eeb@example.com"})
          |> User.generate_otp()

    assert bob.otp
    assert jim.otp
    assert eeb.otp

    Mapping.add(bob)
    Mapping.add(jim)

    assert nil == Mapping.find_by_otp(eeb.otp)
    assert bob == Mapping.find_by_otp(bob.otp)
    assert jim == Mapping.find_by_otp(jim.otp)
  end

  test "find_by_file returns first matching user" do
    bob_params = %{
      "email" => "bob@example.com",
      "file" => %Plug.Upload{path: "test/fixtures/face.jpg", filename: "bob.jpg"},
    }
    bob = User.new(bob_params)
    jim_params = %{
      "email" => "jim@example.com",
      "file" => %Plug.Upload{path: "test/fixtures/face.jpg", filename: "jim.jpg"},
    }
    jim = User.new(jim_params)
    eeb_params = %{
      "email" => "eeb@example.com",
      "file" => %Plug.Upload{path: "test/fixtures/face.jpg", filename: "eeb.jpg"},
    }
    _eeb = User.new(eeb_params)
    Mapping.add(bob)
    Mapping.add(jim)

    assert nil == Mapping.find_by_file(eeb_params["file"])
    assert bob == Mapping.find_by_file(bob_params["file"])
    assert jim == Mapping.find_by_file(jim_params["file"])
  end

  test "find_by_email returns first matching user" do
    bob = User.new(%{"email" => "bob@example.com"})
    jim = User.new(%{"email" => "jim@example.com"})
    eeb = User.new(%{"email" => "eeb@example.com"})

    Mapping.add(bob)
    Mapping.add(jim)

    assert nil == Mapping.find_by_email(eeb.email)
    assert bob == Mapping.find_by_email(bob.email)
    assert jim == Mapping.find_by_email(jim.email)
  end

  test "find_user returns first matching user" do
    bob = User.new(%{"email" => "bob@example.com", "face_id" => "bob"})
    jim = User.new(%{"email" => "jim@example.com", "face_id" => "jim"})
    eeb = User.new(%{"email" => "eeb@example.com"})

    Mapping.add(bob)
    Mapping.add(jim)

    assert bob == Mapping.find_user(bob)
    assert jim == Mapping.find_user(jim)
    assert nil == Mapping.find_user(eeb)
  end

  test "update removes the existing user and adds the new one" do
    bob = User.new(%{"email" => "bob@example.com"})
    new_bob = %{bob | otp: "abc123"}
    refute bob.otp
    assert new_bob.otp

    updated_bob = Mapping.update(new_bob)
    assert updated_bob.otp
    assert [updated_bob] == Mapping.get()
  end
end
