defmodule CLI do
  @builtins ["echo", "exit", "type", "pwd"]

  def main(_args) do
    loop()
  end

  defp loop(:ok, :exit), do: System.halt(0)
  defp loop(_, :exit), do: System.halt(1)

  defp find_exec(cmd) do
    case System.find_executable(cmd) do
      nil -> {:error, :not_found, cmd}
      cmd_path -> {:ok, cmd_path, cmd}
    end
  end

  defp print_command_type(cmd) when cmd in @builtins do
    IO.puts("#{cmd} is a shell builtin")
  end

  defp print_command_type(cmd) do
    case find_exec(cmd) do
      {:error, :not_found, cmd} -> IO.puts("#{cmd}: not found")
      {:ok, cmd_path, _} -> IO.puts(cmd_path)
    end
  end

  defp loop() do
    IO.write("$ ")

    command_split =
      IO.gets("")
      |> String.trim()
      |> String.split(" ")

    case command_split do
      ["cd", "~"] ->
        home = System.user_home()
        File.cd(home)
        loop()

      ["cd", dir] ->
        with :ok <- File.cd(dir) do
          loop()
        else
          {:error, _reason} ->
            IO.puts("cd: #{dir}: No such file or directory")
            loop()
        end

      # Since String.split mutates everything into a [], we need to use the '|' -I think, anyway.
      ["pwd"] ->
        case File.cwd() do
          {:ok, dir} ->
            IO.puts(dir)

          {:error, _} ->
            IO.puts("You're never going to see this message LOL")
        end

        loop()

      ["echo" | args] ->
        text = Enum.join(args, " ")
        IO.puts("#{text}")
        loop()

      ["exit" | _] ->
        loop(:ok, :exit)

      ["type", cmd] ->
        print_command_type(cmd)
        loop()

      [cmd | args] ->
        case find_exec(cmd) do
          {:error, :not_found, cmd} ->
            IO.puts("#{cmd}: command not found")

          {:ok, cmd_path, cmd} ->
            System.cmd(cmd_path, args, arg0: cmd, into: IO.stream())
        end

        loop()
    end
  end
end
