defmodule Mix.Tasks.Deploy do
  use Mix.Task

  @shortdoc "Deploy current release."
  def run(_) do
    general()
  end

  defp general() do
    Mix.shell().info("Deploy release with Ansible")
    Mix.shell().info("\nAvailable tasks:\n")
    Mix.Tasks.Help.run(["--search", "deploy."])
  end
end
