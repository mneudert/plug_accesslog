defmodule Plug.AccessLog.DefaultFormatter.RequestHeader do
  @moduledoc """
  Fetches a request header for logging.
  """

  import Plug.Conn

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t, String.t) :: iodata
  def format(conn, header) do
    case get_req_header(conn, header |> String.downcase) do
      [ value ] -> value
      _         -> "-"
    end
  end
end
