defmodule Gmax.Delivery.Supervisor do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_sender(user) do
    child_spec = %{
      id: Gmax.Delivery.Sender,
      start: {Gmax.Delivery.Sender, :start_link, [user]},
      restart: :temporary,
      type: :worker
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def count_sender() do
    DynamicSupervisor.count_children(__MODULE__)
  end

  @impl true
  def init(init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
