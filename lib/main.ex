defmodule CLI do
  @builtins ["echo", "exit", "type", "pwd"]

  def main(_args) do
    # initialize supervisor here before calling loop()
    loop()
  end

  defp loop(:ok, :exit), do: System.halt(0)
  defp loop(_, :exit), do: System.halt(1)

  defp loop() do
    IO.write("$ ")

    [cmd | args] =
      IO.gets("")
      |> String.trim()
      |> Args.parse()

    execute(cmd, args)
    loop()
  end

  # |> OptionParser.split()
  # |> String.split(" ")

  defp execute("cd", ["~"]) do
    home = System.user_home()
    File.cd(home)
  end

  defp execute("type", [cmd]) when cmd in @builtins, do: IO.puts("#{cmd} is a shell builtin")

  defp execute("type", [cmd]) do
    case System.find_executable(cmd) do
      nil -> IO.puts("#{cmd}: not found")
      cmd_path -> IO.puts(cmd_path)
    end
  end

  defp execute("cd", [dir]) do
    home = System.fetch_env!("HOME")
    dir = String.replace(dir, "~", home)

    case File.cd(dir) do
      :ok ->
        nil

      {:error, :enoent} ->
        IO.puts("cd: #{dir}: No such file or directory")
    end
  end

  defp execute("pwd", _args) do
    case File.cwd() do
      {:ok, dir} -> IO.puts(dir)
      {:error, _} -> IO.puts("Your never going to see this LOL")
    end
  end

  defp execute("echo", [args]) do
    args
    |> Enum.join(" ")
    # |> String.replace("\\", "")
    |> IO.puts()
  end

  defp execute("exit", _), do: loop(:ok, :exit)

  # Catch any-clause
  defp execute(cmd, [args]) do
    case System.find_executable(cmd) do
      nil ->
        IO.puts("#{cmd}: command not found")

      cmd_path ->
        {:ok, cmd_path, cmd}
        System.cmd(cmd_path, args, arg0: cmd, into: IO.stream())
    end
  end
end
