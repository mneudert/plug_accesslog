defmodule Plug.AccessLog.DefaultFormatter.ResponseHeader do
  @moduledoc """
  Fetches a response header for logging.
  """

  import Plug.Conn

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t(), String.t()) :: iodata
  def format(conn, header) do
    header = String.downcase(header)

    case get_resp_header(conn, header) do
      [] -> "-"
      [value | _] -> value
    end
  end
end
