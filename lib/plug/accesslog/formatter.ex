defmodule Plug.AccessLog.Formatter do
  @moduledoc """
  Log message formatter.
  """

  import Plug.Conn

  @doc """
  Formats a log message.

  If no `format` is given a default will be used.

  The following format values are supported:

  - `%b` - Size of response in bytes
  - `%h` - Remote IP of the client
  - `%r` - First line of HTTP request
  - `%>s` - Response status code

  For now the http version written to the log message
  will always be "HTTP/1.1", regardless of the true http version.
  """
  @spec format(format :: atom | String.t, conn :: Plug.Conn.t) :: String.t
  def format(nil, conn), do: format(:default, conn)

  def format(:default, conn) do
    "%h \"%r\" %>s %b" |> format(conn)
  end

  def format(format, conn) when is_binary(format) do
    format(format, conn, "")
  end


  # Internal construction methods

  defp format(<< "%b", rest :: binary >>, conn, message) do
    content_length = case get_resp_header(conn, "Content-Length") do
      [ length ] -> length
      _          -> (conn.resp_body || "") |> byte_size()
    end

    if 0 == content_length do
      content_length = "-"
    end

    format(rest, conn, message <> to_string(content_length))
  end

  defp format(<< "%h", rest :: binary >>, conn, message) do
    remote_ip = conn.remote_ip |> :inet_parse.ntoa() |> to_string()

    format(rest, conn, message <> remote_ip)
  end

  defp format(<< "%r", rest :: binary >>, conn, message) do
    request = conn.method <> " " <> full_path(conn) <> " HTTP/1.1"

    format(rest, conn, message <> request)
  end

  defp format(<< "%>s", rest :: binary >>, conn, message) do
    status = conn.status |> to_string()

    format(rest, conn, message <> status)
  end

  defp format(<< char, rest :: binary >>, conn, message) do
    format(rest, conn, message <> << char >>)
  end

  defp format("", _conn, message), do: message
end
