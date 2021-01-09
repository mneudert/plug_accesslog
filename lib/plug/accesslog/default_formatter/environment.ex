defmodule Plug.AccessLog.DefaultFormatter.Environment do
  @moduledoc """
  Fetches an environment variable for logging.
  """

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t(), String.t()) :: binary
  def format(_conn, var), do: System.get_env(var) || ""
end
