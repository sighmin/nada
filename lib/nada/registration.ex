defmodule Nada.Registration do
  @registration_confidence 95.0
  alias Nada.{User,Mapping,Email,Mailer,Files,FaceApi}

  def identity_claim(user_params = %{ "file" => file_params }) do
    new_user = User.new(user_params)

    {:ok, file_data} = File.read(file_params.path)
    {:ok, _} = Files.put(new_user.file.file_id, file_data)

    {:ok, %{
      "face_id" => face_id,
      "confidence" => confidence,
    }} = FaceApi.register(new_user.file.file_id)

    existing_user = Mapping.find_user(new_user)

    case {existing_user, confidence} do
      {nil, confidence} when confidence >= @registration_confidence ->
        new_user = %{new_user | face_id: face_id, registration_confidence: confidence}
        Mapping.add(new_user)
        new_user
        |> Email.confirm_email
        |> Mailer.deliver_later
        {:ok, new_user}
      {nil, confidence} when confidence < @registration_confidence ->
        {:error, "Can't use that face."}
      {user, _confidence} ->
        {:error, "User email or face already taken."}
      {_, _} ->
        {:error, "Something went wrong."}
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
