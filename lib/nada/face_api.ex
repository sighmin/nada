defmodule Nada.FaceApi do
  # mendes:help a good use case for Elixir behaviours?
  @adapter Application.get_env(:nada, __MODULE__)[:adapter]

  defdelegate register(file_id), to: @adapter
  defdelegate search(file_id), to: @adapter
end

defmodule Nada.FaceApi.Test do
  def register(_file_id) do
    {:ok, %{
      "face_id" => "abc123",
      "image_id" => "def456",
      "confidence" => 99.67,
      "response" => %{},
    }}
  end

  def search(_file_id) do
    {:ok, %{
      "matches" => [%{
        "face_id" => "abc123",
        "similarity" => 0.96,
      }],
      "response" => %{},
    }}
  end
end

defmodule Nada.FaceApi.Live do
  def register(file_id) do
    url = build_url("/api/faces")
    params = build_params(file_id, "face")
    request(url, params)
  end

  def search(file_id) do
    url = build_url("/api/search")
    params = build_params(file_id, "search")
    request(url, params)
  end

  defp request(url, params) do
    Nada.HTTP.post(url, params, fn body ->
      Poison.decode!(body)
    end)
  end

  defp build_url(endpoint) do
    base_url = Map.fetch!(System.get_env(), "FACES_API_URL")
    auth_token = "?secret=" <> Map.fetch!(System.get_env(), "FACES_API_SECRET")
    base_url <> endpoint <> auth_token
  end

  defp build_params(file_id, object) do
    Poison.encode!(%{
      object => %{
        "file_id" => file_id
      }
    })
  end
end
