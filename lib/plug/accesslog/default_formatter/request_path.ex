defmodule Plug.AccessLog.DefaultFormatter.RequestPath do
  @moduledoc """
  Logs request path without query string.
  """

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t) :: String.t
  def append(message, conn), do: message <> conn.request_path
end
