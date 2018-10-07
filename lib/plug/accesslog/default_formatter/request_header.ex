defmodule Plug.AccessLog.DefaultFormatter.RequestHeader do
  @moduledoc """
  Fetches a request header for logging.
  """

  import Plug.Conn

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t(), String.t()) :: iodata
  def format(conn, header) do
    header = String.downcase(header)

    case get_req_header(conn, header) do
      [] -> "-"
      [value | _] -> value
    end
  end
end
