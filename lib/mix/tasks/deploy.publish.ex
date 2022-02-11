defmodule Mix.Tasks.Deploy.Publish do
  use Mix.Task

  @shortdoc "Publish current release."
  def run(args) do
    System.cwd() |> Path.join("deploy") |> File.cd()

    System.cmd("ansible-playbook", args ++ ~w[playbooks/publish.yml],
      env: [{"ANSIBLE_FORCE_COLOR", "true"}],
      into: IO.stream(:stdio, :line)
    )
  end
end
