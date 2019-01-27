defmodule Nada.User do
  defstruct [:email, :file, token: :generate_token]

  def new(params) do
    struct(__MODULE__, build_params(params))
  end

  def build_params(params) do
    params
    |> Map.Helpers.atomize_keys()
    |> Map.merge(%{token: generate_token()})
  end

  defp generate_token do
    Enum.take_random(?a..?z, 5)
  end
end
