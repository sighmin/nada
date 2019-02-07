defmodule Nada.Registration do
  alias Nada.{User,Mapping,Email,Mailer,Files,FaceApi}

  def identity_claim(user_params = %{ "file" => file_params }) do
    user = User.new(user_params)

    {:ok, file_data} = File.read(file_params.path)
    {:ok, _} = Files.put(user.file.file_id, file_data)

    {:ok, %{
      "face_id" => face_id,
      "confidence" => confidence,
    }} = FaceApi.register(user.file.file_id)

    if Mapping.find_user(user) do
      {:error, "User email or face already taken."}
    else
      user = %{user | face_id: face_id, registration_confidence: confidence}
      Mapping.add(user)

      user
      |> Email.confirm_email
      |> Mailer.deliver_later

      {:ok, user}
    end
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
