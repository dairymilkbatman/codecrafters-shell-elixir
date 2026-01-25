defmodule CLI do
  def main(_args) do
    IO.write("$ ")
    command = IO.gets("") |> String.trim()
    IO.puts("#{command}: command not found")
    repl()
  end

  defp repl() do 
    CLI.main("")
  end
end

