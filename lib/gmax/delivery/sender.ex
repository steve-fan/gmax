defmodule Gmax.Delivery.Sender do
  use GenServer
  require Logger

  @cont_interval 100
  @retry_interval 2_000
  # 24h and 10m
  @limit_reached_interval 87_000_000

  def start_link(user) do
    GenServer.start_link(__MODULE__, {0, user}, name: :"sender-#{user.email}")
  end

  def start(pid) do
    GenServer.cast(pid, :start)
  end

  def hang_on(pid) do
    GenServer.cast(pid, :hang_on)
  end

  def stop(pid) do
    GenServer.cast(pid, :stop)
  end

  # Callbacks

  def init({_status, _user} = state) do
    GenServer.cast(self(), :start)
    {:ok, state}
  end

  def handle_cast(:start, {_status, user}) do
    Logger.info("#{user.id}-cast:start...")

    continue(user)

    {:noreply, {1, user}}
  end

  def handle_cast(:hang_on, {_status, user}) do
    Logger.info("#{user.id}-cast:hang_on")
    Process.send_after(self(), :start, @limit_reached_interval)
    {:noreply, {0, user}}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_info(:start, {_status, user}) do
    Logger.info("#{user.id}-info:start...")
    continue(user)

    {:noreply, {1, user}}
  end

  def handle_info(:stop, {_status, user} = state) do
    Logger.info("#{user.id}-info:stop...")
    {:stop, :normal, state}
  end

  def handle_info(:cont, {status, user} = state) do
    Logger.info("#{user.id}-info:cont")

    case status do
      0 ->
        {:noreply, {0, user}}

      1 ->
        continue(user)
        {:noreply, state}
    end
  end

  def continue(user) do
    interval =
      case Gmax.Mailer.send_draft(user) do
        {:ok, _message} ->
          Logger.info("#{user.id}-continue in #{@cont_interval / 1000} seconds...")
          Process.send_after(self(), :cont, @cont_interval)

        {:nomore} ->
          send(self(), :stop)

        {:limit_reached, _reason} ->
          Logger.info("#{user.id}-continue in #{@limit_reached_interval / 1000} seconds...")
          Process.send_after(self(), :cont, @limit_reached_interval)

        {:error, _body} ->
          Logger.info("#{user.id}-continue in #{@retry_interval / 1000} seconds...")
          Process.send_after(self(), :cont, @retry_interval)
      end
  end
end
