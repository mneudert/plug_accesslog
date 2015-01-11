defmodule Plug.AccessLog.Writer do
  @moduledoc """
  Log message writer.
  """

  @doc """
  Writes a log message.
  """
  @spec write(message :: String.t, logfile :: File.io_device) :: :ok
  def write(message, logfile), do: IO.write(logfile, message <> "\n")
end
