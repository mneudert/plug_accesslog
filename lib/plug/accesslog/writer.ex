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
  @spec start_link(list) :: GenServer.on_start
  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def init(state) do
    Process.send_after(self, :trigger, 100)

    { :ok, state }
  end


  # GenServer callbacks

  def handle_call({ :register_file, logfile }, _, state) do
    { :reply, :ok, Enum.uniq([ logfile | state ]) }
  end

  def handle_info(:trigger, state) do
    Enum.each state, &write/1

    Process.send_after(self, :trigger, 100)

    { :noreply, state }
  end


  # Convenience methods

  @doc """
  Registers a logfile for writing.
  """
  @spec register_file(String.t) :: :ok
  def register_file(logfile) do
    GenServer.call(__MODULE__, { :register_file, logfile }, :infinity)
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
