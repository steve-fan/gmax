defmodule Mix.Tasks.Deploy.Restart do
  use Mix.Task

  @shortdoc "Restart server"
  def run(args) do
    System.cwd() |> Path.join("deploy") |> File.cd()

    System.cmd("ansible-playbook", args ++ ~w[playbooks/restart.yml],
      env: [{"ANSIBLE_FORCE_COLOR", "true"}],
      into: IO.stream(:stdio, :line)
    )
  end
end
