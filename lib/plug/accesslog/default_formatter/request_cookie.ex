defmodule Plug.AccessLog.DefaultFormatter.RequestCookie do
  @moduledoc """
  Fetches a cookie sent by the client for logging.
  """

  import Plug.Conn

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t(), String.t()) :: iodata
  def format(conn, cookie) do
    case fetch_cookies(conn) do
      %{cookies: %{^cookie => value}} -> value
      _ -> "-"
    end
  end
end
