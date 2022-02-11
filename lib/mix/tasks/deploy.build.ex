defmodule Mix.Tasks.Deploy.Build do
  use Mix.Task

  @shortdoc "Build release."
  def run(_) do
    path = File.cwd!()

    IO.puts("Building release with docker...")

    {_, 0} =
      System.cmd(
        "docker",
        ~w[run -v #{path}:/opt/build --rm -t elixir-centos:latest /opt/build/deploy/build-release.sh],
        into: IO.stream(:stdio, :line)
      )
  end
end
