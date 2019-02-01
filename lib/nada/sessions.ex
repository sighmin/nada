defmodule Nada.Sessions do
  alias Nada.{Mapping,Files,Random,FaceApi,User,Email,Mailer}

  def find_user_from_face(file) do
    # upload image to s3
    {:ok, file_data} = File.read(file.path)
    file_id = Random.generate_unique_file_id(file.filename)
    {:ok, _} = Files.put(file_id, file_data)

    # search for face in image and get face_id
    {:ok, %{ "matches" => matches }} = FaceApi.search(file_id)
    match = matches |> List.first |> IO.inspect
    %{ "face_id" => face_id, "similarity" => _similarity } = match

    # find user in the mapping by face_id
    Mapping.find_by_face_id(face_id)
  end

  def identity_challenge(user) do
    user
    |> User.generate_otp
    |> Mapping.update
    |> Email.confirm_otp
    |> Mailer.deliver_now
  end

  def complete_login(user) do
    user
    |> User.clear_tokens
    |> Mapping.update
  end
end
