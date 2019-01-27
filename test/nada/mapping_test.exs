defmodule Nada.MappingTest do
  use ExUnit.Case
  alias Nada.{Mapping,User}

  setup do
    on_exit fn ->
      Mapping.flush()
    end
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
end
