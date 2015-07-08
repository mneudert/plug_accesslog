defmodule Plug.AccessLog.DefaultFormatter.ResponseHeader do
  @moduledoc """
  Fetches a response header for logging.
  """

  import Plug.Conn

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t, String.t) :: String.t
  def append(message, conn, header) do
    case get_resp_header(conn, header |> String.downcase) do
      [ value ] -> message <> value
      _         -> message <> "-"
    end
  end
end
