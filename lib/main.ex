defmodule CLI do
  def main(_args) do
    command = IO.gets("") |> String.trim()
    IO.puts("#{command}: command not found")
  end
end
