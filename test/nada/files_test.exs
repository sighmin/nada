defmodule FilesTest do
  use ExUnit.Case, async: true
  alias Nada.Files

  test ".list gets a list of files" do
    response = Files.list

    assert {:ok, files} = response
    assert files == [%{file_id: "abc123-face.jpg"}]
  end

  test ".get gets a file" do
    response = Files.get("def456-face.jpg")

    assert {:ok, file} = response
    assert file == <<255, 255, 255>>
  end

  test ".put uploads a file" do
    {:ok, file_data} = File.read(
      File.cwd! <> "/test/fixtures/face.jpg"
    )
    file_id = "face.jpg"
    response = Files.put(file_id, file_data)

    assert {:ok, ""} = response
  end
end
