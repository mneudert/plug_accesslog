defmodule Plug.AccessLog.Formatter.RequestCookie do
  @moduledoc """
  Fetches a cookie sent by the client for logging.
  """

  import Plug.Conn

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t, String.t) :: String.t
  def append(message, conn, cookie) do
    conn = conn |> fetch_cookies()

    case Map.get(conn.cookies, cookie) do
      nil   -> message <> "-"
      value -> message <> value
    end
  end
end
