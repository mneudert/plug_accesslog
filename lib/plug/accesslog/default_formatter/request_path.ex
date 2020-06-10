defmodule Plug.AccessLog.DefaultFormatter.RequestPath do
  @moduledoc """
  Logs request path without query string.
  """

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t()) :: iodata
  def format(%{request_path: request_path}), do: request_path
end
