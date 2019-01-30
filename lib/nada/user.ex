defmodule Nada.User do
  defstruct [:email, :file, :token, :otp]
  alias Nada.Random

  def new(params) do
    struct(__MODULE__, build_params(params))
  end

  def build_params(params) do
    params
    |> Map.Helpers.atomize_keys()
    |> Map.merge(%{token: Random.generate})
  end

  def generate_otp(user) do
    %{user | otp: Random.generate}
  end

  def clear_tokens(user) do
    %{user | token: nil, otp: nil}
  end
end
