defmodule Nada.Registration do
  alias Nada.{Random,User,Mapping,Email,Mailer,Files}

  def identity_claim(user_params = %{ "file" => file_params }) do
    # generate unique file_id
    file_id = generate_unique_file_id(file_params)
    {:ok, file_data} = File.read(Map.fetch!(file_params, :path))

    # upload to s3
    Files.put(file_id, file_data)

    # add user to Mapping
    user = User.new(user_params)
    Mapping.add(user)

    # send email confirmation
    user
    |> Email.confirm_email
    |> Mailer.deliver_now
  end

  def identity_verification(token) do
    Mapping.find_by_token(token)
  end

  def complete_registration(user) do
    user
    |> User.clear_tokens
    |> Mapping.update
  end

  defp generate_unique_file_id(file_params) do
    "#{Random.generate}-#{Map.fetch!(file_params, :filename)}"
  end
end
