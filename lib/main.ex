defmodule CLI do
  require Logger

  def main(_args) do
    loop()
  end

  defp loop(:ok, :exit), do: System.halt(0)
  defp loop(_, :exit), do: System.halt(1)

  defp loop() do
    IO.write("$ ")
    input = IO.gets("") |> String.trim()
    split_string = String.split(input, " ")

    case split_string do
      ["exit" | _] ->
        loop(:ok, :exit)

      ["echo" | argument] ->
        args = Enum.join(argument, " ")
        IO.puts("#{args}")
        loop()

      ["type" | argument] ->
        case argument do
          ["echo"] ->
            IO.puts("echo is a shell builtin")

          ["ls"] ->
            List.to_string(argument)
            |> System.find_executable()
            |> IO.puts()

          ["exit"] ->
            IO.puts("exit is a shell builtin")

          ["type"] ->
            IO.puts("type is a shell builtin")

          _ ->
            IO.puts("#{argument}: not found")
        end

        loop()

      [unknown_cmd | _] ->
        IO.puts("#{unknown_cmd}: command not found")
        loop()
    end
  end
end
