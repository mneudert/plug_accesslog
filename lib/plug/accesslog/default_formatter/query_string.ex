defmodule Plug.AccessLog.DefaultFormatter.QueryString do
  @moduledoc """
  Logs the query string.
  """

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t) :: iodata
  def format(conn) do
    case conn.query_string do
      ""    -> ""
      query -> [ "?", query ]
    end
  end
end
