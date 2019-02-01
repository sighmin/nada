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

  def get() do
    Agent.get(@name, fn state -> state end)
  end

  def update(user) do
    # find user in the mapping
    old_user = find_by(fn(u) ->
      u.email == user.email
    end)
    # remove that user
    Agent.update(@name, fn(list) ->
      List.delete(list, old_user)
    end)
    # add this updated user
    add(user)
    user
  end

  def find_by_token(token) do
    find_by(fn(user) ->
      user.token == token
    end)
  end

  def find_by_otp(otp) do
    find_by(fn(user) ->
      user.otp == otp
    end)
  end

  def find_by_email(email) do
    find_by(fn(user) ->
      user.email == email
    end)
  end

  def find_by_file(file) do
    find_by(fn(user) ->
      user.file.file_name == file.filename
    end)
  end

  def find_by_face_id(face_id) do
    find_by(fn(user) ->
      user.face_id == face_id
    end)
  end

  def flush() do
    Agent.update(__MODULE__, fn _state ->
      []
    end)
  end

  defp find_by(block) do
    list = Nada.Mapping.get()
    Enum.find(list, block)
  end
end
