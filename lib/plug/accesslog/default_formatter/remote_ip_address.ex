defmodule Plug.AccessLog.DefaultFormatter.RemoteIPAddress do
  @moduledoc """
  Determines remote ip address.
  """

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t) :: iodata
  def format(conn) do
    conn.remote_ip
    |> :inet_parse.ntoa()
    |> to_string()
  end
end
