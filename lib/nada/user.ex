defmodule Nada.User do
  defstruct [:email, :file, :token, :otp]

  def new(params) do
    struct(__MODULE__, build_params(params))
  end

  def build_params(params) do
    params
    |> Map.Helpers.atomize_keys()
    |> Map.merge(%{token: generate_token()})
  end

  def generate_otp(user) do
    %{user | otp: generate_token()}
  end

  def clear_tokens(user) do
    %{user | token: nil, otp: nil}
  end

  defp generate_token do
    Enum.take_random(?a..?z, 5)
    |> to_string()
  end
end
