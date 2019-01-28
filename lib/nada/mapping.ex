defmodule Nada.Mapping do
  use Agent

  def start(args \\ []) do
    Nada.Mapping.start_link(args)
  end

  def start_link(_args) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add(user) do
    Agent.update(__MODULE__, fn list ->
      [user | list]
    end)
  end

  def get() do
    Agent.get(__MODULE__, fn state -> state end)
  end

  def find_by_token(token) do
    list = Nada.Mapping.get()
    Enum.find(list, fn(user) ->
      user.token == token
    end)
  end

  def find_by_file(file) do
    list = Nada.Mapping.get()
    Enum.find(list, fn(user) ->
      user.file.filename == file.filename
    end)
  end

  def flush() do
    Agent.update(__MODULE__, fn _state ->
      []
    end)
  end
end
