defmodule Plug.AccessLog.DefaultFormatter.RemoteIPAddress do
  @moduledoc """
  Determines remote ip address.
  """

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t()) :: iodata
  def format(%{remote_ip: remote_ip}), do: :inet_parse.ntoa(remote_ip)
end
