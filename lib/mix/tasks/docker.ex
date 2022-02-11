defmodule Mix.Tasks.Docker do
  use Mix.Task

  @shortdoc "Build docker image which will be used to build production release."

  def run(_) do
    {_, 0} =
      System.cmd("docker", ~w[build -t local/centos-systemd:latest docker/centos-systemd],
        into: IO.stream(:stdio, :line)
      )

    {_, 0} =
      System.cmd("docker", ~w[build -t elixir-centos:latest docker/elixir],
        into: IO.stream(:stdio, :line)
      )
  end
end
