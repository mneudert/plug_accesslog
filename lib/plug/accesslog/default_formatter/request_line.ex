defmodule Plug.AccessLog.DefaultFormatter.RequestLine do
  @moduledoc """
  Recreates the first line of the original HTTP request.
  """

  import Plug.Conn

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t()) :: iodata
  def format(%{method: method, request_path: request_path} = conn) do
    protocol =
      conn
      |> get_http_protocol()
      |> to_string()

    [method, " ", request_path, " ", protocol]
  end
end
