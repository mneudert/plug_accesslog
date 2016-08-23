defmodule Plug.AccessLog.DefaultFormatter.Environment do
  @moduledoc """
  Fetches an environment variable for logging.
  """

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t, String.t) :: String.t
  def append(message, _conn, var), do: message <> (System.get_env(var) || "")
end
