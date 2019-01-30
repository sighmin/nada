defmodule Aws do
  # mendes:help a good use case for Elixir behaviours?
  @adapter Application.get_env(:nada, __MODULE__)[:adapter]

  defdelegate request(operation), to: @adapter
  defdelegate get_object(bucket, object), to: @adapter
  defdelegate list_objects(bucket), to: @adapter
  defdelegate put_object(bucket, object, body), to: @adapter
end

defmodule Aws.Live do
  defdelegate request(operation), to: ExAws
  defdelegate get_object(bucket, object), to: ExAws.S3
  defdelegate list_objects(bucket), to: ExAws.S3
  defdelegate put_object(bucket, object, body), to: ExAws.S3
end
