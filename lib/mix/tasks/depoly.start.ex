defmodule Mix.Tasks.Deploy.Start do
  use Mix.Task

  @shortdoc "Start server."
  def run(args) do
    System.cwd() |> Path.join("deploy") |> File.cd()

    System.cmd("ansible-playbook", args ++ ~w[playbooks/start.yml],
      env: [{"ANSIBLE_FORCE_COLOR", "true"}],
      into: IO.stream(:stdio, :line)
    )
  end
end
