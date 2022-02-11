defmodule Gmax.Delivery do
  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)

    children = [Gmax.Delivery.Supervisor]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def start_sender_if_needed(user) do
    sender_name = :"sender-#{user.email}"

    case Process.whereis(sender_name) do
      nil ->
        Gmax.Delivery.Supervisor.start_sender(user)

      sender ->
        {:ok, sender}
    end
  end

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end
end
