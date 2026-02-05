defmodule ExampleTest do
  use ExUnit.Case

  test "Loop returns something" do
    refute(CLI.loop() == nil)
  end
end
