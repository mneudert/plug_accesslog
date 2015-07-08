defmodule Plug.AccessLog.Writer.Watcher do
  @moduledoc """
  Watches over the writer event handler.
  """

  use GenServer


  # GenServer lifecycle

  @doc """
  Starts the watcher process.
  """
  @spec start_link(module) :: GenServer.on_start
  def start_link(manager) do
    GenServer.start_link(__MODULE__, manager, [])
  end

  def init(manager) do
    :ok = start_handler(manager)

    { :ok, manager }
  end


  # GenServer callbacks

  def handle_info({ :gen_event_EXIT, _handler, reason }, manager)
      when reason in [ :normal, :shutdown ]
  do
    { :stop, reason, manager }
  end

  def handle_info({ :gen_event_EXIT, _handler, _reason }, manager) do
    :ok = start_handler(manager)

    { :noreply, manager }
  end


  # Internal methods

  defp start_handler(manager) do
    GenEvent.add_mon_handler(manager, Plug.AccessLog.Writer, self)
  end
end
