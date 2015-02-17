defmodule Plug.AccessLog.Formatter.RemoteHostname do
  @moduledoc """
  Determines remote hostname.
  """

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t) :: String.t
  def append(message, conn), do: message <> remote_hostname(conn)

  defp remote_hostname(conn) do
    conn.remote_ip
    |> :inet_parse.ntoa()
    |> to_string()
  end
end
