defmodule Nada.UserTest do
  use ExUnit.Case
  alias Nada.User

  test "new generates a user from params" do
    params = %{ "email" => "bob@email.com" }
    user = User.new(params)
    assert params["email"], user.email
    assert user.token
  end
end
