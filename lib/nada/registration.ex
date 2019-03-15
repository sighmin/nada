defmodule Nada.Registration do
  @registration_confidence 95.0
  alias Nada.{User,Mapping,Email,Mailer,Files,FaceApi}

  defguard confident(confidence) when confidence >= @registration_confidence

  def identity_claim(user_params = %{ "file" => file_params }) do
    with new_user <- User.new(user_params),
         {:ok, file_data} <- File.read(file_params.path),
         {:ok, _} <- Files.put(new_user.file.file_id, file_data),
         {:ok, %{"face_id" => face_id, "confidence" => confidence}} <-
           FaceApi.register(new_user.file.file_id) do
      new_user
      |> Mapping.find_user()
      |> confirm_and_add_user(new_user, confidence, face_id)
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

  defp confirm_and_add_user(nil, user, confidence, face_id)
  when confident(confidence) do
    new_user = %{user | face_id: face_id, registration_confidence: confidence}

    Mapping.add(new_user)
    email_user(new_user)

    {:ok, new_user}
  end

  defp confirm_and_add_user(nil, _, _, _),
    do: {:error, "Can't use that face."}

  defp confirm_and_add_user(_, _, _, _),
    do: {:error, "User email or face already taken"}

  defp email_user(user) do
    user
    |> Email.confirm_email
    |> Mailer.deliver_later
  end
end
