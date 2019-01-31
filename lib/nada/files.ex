defmodule Nada.Files do
  @bucket Map.fetch!(System.get_env(), "AWS_S3_BUCKET")
  @default_error {:error, "Files: Unknown error occured talking to s3"}

  def get(file_key) do
    @bucket
    |> AwsApi.get_object(file_key)
    |> AwsApi.request
    |> format_file
  end

  def list do
    @bucket
    |> AwsApi.list_objects
    |> AwsApi.request
    |> format_files
  end

  def put(file_id, file_data) do
    @bucket
    |> AwsApi.put_object(file_id, file_data)
    |> AwsApi.request
    |> format_file
  end

  defp format_file(response) do
    case response do
      {:ok, %{ status_code: 200, body: body }} ->
        {:ok, body}
      {:error, error} ->
        {:error, error}
      _ -> @default_error
    end
  end

  defp format_files(response) do
    case response do
      {:ok, %{ status_code: 200, body: %{ contents: files } }} ->
        {:ok, extract_file_id(files)}
      {:error, error} ->
        {:error, error}
      _ -> @default_error
    end
  end

  defp extract_file_id(files) do
    files |> Enum.map(fn(file) ->
      %{ file_id: Map.fetch!(file, :key) }
    end)
  end
end
