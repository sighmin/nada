defmodule Nada.HTTP do
  def post(url, params, fun) do
    request(:post, url, params, fun)
  end

  defp request(method, url, params, fun) do
    response = HTTPoison.request(method, url, params, headers())

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        fun.(body)
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
        {:error, reason}
    end
  end

  defp headers do
    [
      {"Content-Type", "application/json"},
      {"Accept", "Application/json; Charset=utf-8"}
    ]
  end
end
