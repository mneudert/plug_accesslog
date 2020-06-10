defmodule Plug.AccessLog.DefaultFormatter.RequestLine do
  @moduledoc """
  Recreates the first line of the original HTTP request.
  """

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t()) :: iodata
  def format(%{method: method, request_path: request_path}) do
    [method, " ", request_path, " HTTP/1.1"]
  end
end
