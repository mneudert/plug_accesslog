defmodule Plug.AccessLog.Formatter.RequestLine do
  @moduledoc """
  Recreates the first line of the original HTTP request.
  """

  import Plug.Conn

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t) :: String.t
  def append(message, conn) do
    message <> conn.method <> " " <> full_path(conn) <> " HTTP/1.1"
  end
end
