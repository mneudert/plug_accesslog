defmodule Plug.AccessLog.DefaultFormatter.RemoteIPAddress do
  @moduledoc """
  Determines remote ip address.
  """

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t) :: String.t
  def append(message, conn), do: message <> remote_ip_address(conn)

  defp remote_ip_address(conn) do
    conn.remote_ip
    |> :inet_parse.ntoa()
    |> to_string()
  end
end
