defmodule Nada.Sessions do
  alias Nada.{Mapping,Files,Random,FaceApi,User,Email,Mailer}

  def find_user_from_face(%{path: path, filename: filename} = _file) do
    # upload image to s3
    with {:ok, file_data} <- File.read(path),
         file_id <- Random.generate_unique_file_id(filename),
         {:ok, _} <- Files.put(file_id, file_data),
         # search for face in image and get face_id
         {:ok, %{"matches" => matches}} <- FaceApi.search(file_id),
         %{"face_id" => face_id} <- List.first(matches) do
      # find user in the mapping by face_id
      Mapping.find_by_face_id(face_id)
    else
      {:error, _reason} = reason ->
        reason
    end
  end

  def identity_challenge(user) do
    user
    |> User.generate_otp
    |> Mapping.update
    |> Email.confirm_otp
    |> Mailer.deliver_later
  end

  def complete_login(user) do
    user
    |> User.clear_tokens
    |> Mapping.update
  end
end
