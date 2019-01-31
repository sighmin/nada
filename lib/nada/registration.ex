defmodule Nada.Registration do
  alias Nada.{User,Mapping,Email,Mailer,Files}

  def identity_claim(user_params = %{ "file" => file_params }) do
    # create user claim
    user = User.new(user_params)
    Mapping.add(user)

    # upload to s3 for face identification
    {:ok, file_data} = File.read(Map.fetch!(file_params, :path))
    {:ok, _} = Files.put(user.file.file_id, file_data)

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
end
