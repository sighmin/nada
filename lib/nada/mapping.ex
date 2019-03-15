defmodule Nada.Mapping do
  use Agent
  @name __MODULE__

  def start(args \\ []) do
    Nada.Mapping.start_link(args)
  end

  def start_link(_args) do
    Agent.start_link(fn -> [] end, name: @name)
  end

  def add(user) do
    Agent.update(@name, fn(list) ->
      [user | list]
    end)
  end

  def get do
    Agent.get(@name, fn state -> state end)
  end

  def update(%{email: email} = new_user) do
    Agent.update(@name, fn(list) ->
      for user <- list,
        user.email != email,
        do: user,
        into: [new_user]
    end)
    new_user
  end

  def find_by_token(token) do
    find_by(token: token)
  end

  def find_by_otp(otp) do
    find_by(otp: otp)
  end

  def find_by_email(email) do
    find_by(email: email)
  end

  def find_by_file(file) do
    find_by(fn(user) ->
      user.file.file_name == file.filename
    end)
  end

  def find_by_face_id(face_id) do
    find_by(face_id: face_id)
  end

  def find_user(new_user) do
    find_by(fn(user) ->
      user.email == new_user.email ||
        user.face_id == new_user.face_id
    end)
  end

  def flush() do
    Agent.update(__MODULE__, fn _state ->
      []
    end)
  end

  defp find_by([{param, value}]) do
    find_by(fn (user) -> Map.get(user, param) == value end)
  end

  defp find_by(block) do
    list = Nada.Mapping.get()
    Enum.find(list, block)
  end
end
