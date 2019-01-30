defmodule Nada.Random do
  def generate(length \\ 6) do
    Enum.take_random(?a..?z, length)
    |> to_string()
  end
end
