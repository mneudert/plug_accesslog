defmodule Plug.AccessLog.Writer do
  @moduledoc """
  Log message writer.
  """

  use GenEvent

  alias Plug.AccessLog.Logfiles


  @doc """
  Notifies the writer to write a log message.
  """
  @spec notify(String.t, String.t) :: :ok
  def notify(message, logfile) do
    GenEvent.notify(__MODULE__, { :log, message, logfile })
  end


  # GenEvent callbacks

  def handle_event({ :log, message, logfile }, state) do
    { write(message, logfile), state }
  end


  # Utility methods

  defp write(message, logfile) do
    case Logfiles.get(logfile) do
      nil -> :ok
      io  -> IO.write(io, message <> "\n")
    end
  end
end
