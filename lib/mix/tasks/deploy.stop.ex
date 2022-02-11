defmodule Mix.Tasks.Deploy.Stop do
  use Mix.Task

  @shortdoc "Stop server"
  def run(args) do
    IO.inspect(args)
    System.cwd() |> Path.join("deploy") |> File.cd()

    System.cmd("ansible-playbook", args ++ ~w[playbooks/stop.yml],
      env: [{"ANSIBLE_FORCE_COLOR", "true"}],
      into: IO.stream(:stdio, :line)
    )
  end
end
