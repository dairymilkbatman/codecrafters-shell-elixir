defmodule CLI do
  @builtin_commands ["echo", "exit", "type"]

  def main(_args) do
    loop()
  end

  defp loop(:ok, :exit), do: System.halt(0)
  defp loop(_, :exit), do: System.halt(1)

  def loop() do
    IO.write("$ ")

    command_result =
      IO.gets("")
      |> String.trim()
      |> String.split(" ")
      |> process_command()

    case command_result do
      # Don't loop again, exit handlers already called
      :exit -> :ok
      # Continue looping for all other commands matching :continue
      _ -> loop()
    end
  end

  defp process_command(["exit" | _]) do
    loop(:ok, :exit)
    :exit
  end

  defp process_command(["echo" | arguments]) do
    arguments
    |> Enum.join(" ")
    |> IO.puts()

    :continue
  end

  # This works, needs to be dynamic

  defp process_command(["touch" | [arguments]]) do
    if System.find_executable("touch") do
      System.cmd("touch", [arguments], into: IO.stream())
    end
  end

  defp process_command(["type" | [command]]) do
    cond do
      command in @builtin_commands ->
        IO.puts("#{command} is a shell builtin")

      executable_path = System.find_executable(command) ->
        IO.puts("#{command} is #{executable_path}")

      true ->
        IO.puts("#{command}: not found")
    end

    :continue
  end

  defp process_command(["type" | _]) do
    IO.puts("type: too many arguments")
    :continue
  end

  defp process_command([command | _]) do
    IO.puts("#{command}: command not found")
    :continue
  end
end
