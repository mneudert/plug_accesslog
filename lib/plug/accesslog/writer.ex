defmodule Plug.AccessLog.Writer do
  @moduledoc """
  Log message writer.
  """

  use GenServer

  alias Plug.AccessLog.Logfiles
  alias Plug.AccessLog.WAL


  # GenServer lifecycle

  @doc """
  Starts the message writer.
  """
  @spec start_link() :: GenServer.on_start
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(%{}) do
    flush_interval =
      :plug_accesslog
      |> Application.get_env(:wal, [])
      |> Keyword.get(:flush_interval, 100)

    Process.send_after(self, :trigger, flush_interval)

    { :ok, %{ flush_interval: flush_interval } }
  end


  # GenServer callbacks

  def handle_info(:trigger, state) do
    Enum.each(WAL.logfiles, &write/1)
    Process.send_after(self, :trigger, state.flush_interval)

    { :noreply, state }
  end


  # Internal methods

  defp write(logfile) do
    case WAL.flush(logfile) do
      []       -> :ok
      messages ->  messages |> Enum.join("\n") |> write_log(logfile)
    end
  end

  defp write_log("",  _),   do: :ok
  defp write_log(msg, file) do
    case Logfiles.get(file) do
      nil -> :ok
      io  -> IO.write(io, msg <> "\n")
    end
  end
end
