defmodule Nada.User do
  defstruct [:email, :file, :token, :otp, :face_id, :registration_confidence]
  alias Nada.Random

  def new(params) do
    struct(__MODULE__, build_params(params))
  end

  def build_params(params) do
    params
    |> Map.Helpers.atomize_keys
    |> Map.merge(%{file: format_file_params(params)})
    |> Map.merge(%{token: Random.generate})
  end

  def format_file_params(%{ "file" => file_params }) do
    %{
      file_id: Random.generate_unique_file_id(file_params.filename),
      file_name: file_params.filename
    }
  end

  def format_file_params(_) do
    %{}
  end

  def generate_otp(user) do
    %{user | otp: Random.generate}
  end

  def clear_tokens(user) do
    %{user | token: nil, otp: nil}
  end
end
