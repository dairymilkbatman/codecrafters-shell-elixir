defmodule CLI do
  def main(_args) do
    loop()
  end

  defp loop(_, :exit) do
    System.halt(0)
  end

  defp loop() do
    IO.write("$ ")
    command = IO.gets("") |> String.trim()

    case command do
      "exit" ->
        loop(:ok, :exit)

      _ ->
        IO.puts("#{command}: command not found")
        loop()
    end
  end
end
