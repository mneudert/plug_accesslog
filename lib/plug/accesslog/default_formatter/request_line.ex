defmodule Plug.AccessLog.DefaultFormatter.RequestLine do
  @moduledoc """
  Recreates the first line of the original HTTP request.
  """

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t) :: String.t
  def append(message, conn) do
    "#{ message }#{ conn.method } #{ conn.request_path } HTTP/1.1"
  end
end
