defmodule Plug.AccessLog.Writer.Watcher do
  @moduledoc """
  Watches over the writer event handler.
  """

  use GenServer


  def start_link(manager) do
    GenServer.start_link(__MODULE__, manager, [])
  end

  def init(manager) do
    start_handler(manager)

    {:ok, manager}
  end

  def start_handler(manager) do
    :ok = GenEvent.add_mon_handler(manager, Plug.AccessLog.Writer, self)
  end

  def handle_info({ :gen_event_EXIT, _handler, reason }, manager)
      when reason in [ :normal, :shutdown ]
  do
    { :stop, reason, manager }
  end

  def handle_info({ :gen_event_EXIT, _handler, _reason }, manager) do
    start_handler(manager)

    { :noreply, manager }
  end
end
