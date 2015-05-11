defmodule Plug.AccessLog.Formatter.RequestHeader do
  @moduledoc """
  Fetches a request header for logging.
  """

  import Plug.Conn

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t, String.t) :: String.t
  def append(message, conn, header) do
    case get_req_header(conn, header |> String.downcase) do
      [ value ] -> message <> value
      _         -> message <> "-"
    end
  end
end
