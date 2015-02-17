defmodule Plug.AccessLog.Formatter.RequestPath do
  @moduledoc """
  Logs request path without query string.
  """

  import Plug.Conn

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t) :: String.t
  def append(message, conn), do: message <> full_path(conn)
end
