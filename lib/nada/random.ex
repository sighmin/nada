defmodule Nada.Random do
  def generate_unique_file_id(filename) do
    "#{generate()}-#{filename}"
  end

  def generate(length \\ 6) do
    Enum.take_random(?a..?z, length)
    |> to_string()
  end
end
