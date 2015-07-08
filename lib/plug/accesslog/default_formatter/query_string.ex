defmodule Plug.AccessLog.DefaultFormatter.QueryString do
  @moduledoc """
  Logs the query string.
  """

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t) :: String.t
  def append(message, conn) do
    case conn.query_string do
      ""    -> message
      query -> message <> "?" <> query
    end
  end
end
