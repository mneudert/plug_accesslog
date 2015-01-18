defmodule Plug.AccessLog.Formatter do
  @moduledoc """
  Log message formatter.
  """

  use Timex

  import Plug.Conn

  @doc """
  Formats a log message.

  The `:default` format is `:clf`.

  The following formatting directives are available:

  - `%b` - Size of response in bytes
  - `%h` - Remote hostname
  - `%l` - Remote logname
  - `%r` - First line of HTTP request
  - `%>s` - Response status code
  - `%t` - Time the request was received in the format `[10/Jan/2015:14:46:18 +0100]`.
  - `%u` - Remote user

  **Note for %b**: To determine the size of the response the "Content-Length"
  (exact case match required for now!) will be inspected and, if available,
  returned unverified. If the header is not present the response body will be
  inspected using `byte_size/1`.

  **Note for %h**: The hostname will always be the ip of the client.

  **Note for %l**: Always a dash ("-").

  **Note for %r**: For now the http version is always logged as "HTTP/1.1",
  regardless of the true http version.

  **Note for %u**: Currently not supported, defaults to a dash ("-").
  """
  @spec format(format :: atom | String.t, conn :: Plug.Conn.t) :: String.t
  def format(nil,      conn), do: format(:clf, conn)
  def format(:default, conn), do: format(:clf, conn)

  def format(:clf, conn) do
    "%h %l %u %t \"%r\" %>s %b" |> format(conn)
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

  defp format(<< "%l", rest :: binary >>, conn, message) do
    format(rest, conn, message <> "-")
  end

  defp format(<< "%r", rest :: binary >>, conn, message) do
    request = conn.method <> " " <> full_path(conn) <> " HTTP/1.1"

    format(rest, conn, message <> request)
  end

  defp format(<< "%>s", rest :: binary >>, conn, message) do
    status = conn.status |> to_string()

    format(rest, conn, message <> status)
  end

  defp format(<< "%t", rest :: binary >>, conn, message) do
    request_date  = conn.private[:plug_accesslog] |> Date.from(:local)
    format_string = "[%d/%b/%Y:%H:%M:%S %z]"
    request_time  = DateFormat.format!(request_date, format_string, :strftime)

    format(rest, conn, message <> request_time)
  end

  defp format(<< "%u", rest :: binary >>, conn, message) do
    format(rest, conn, message <> "-")
  end

  defp format(<< char, rest :: binary >>, conn, message) do
    format(rest, conn, message <> << char >>)
  end

  defp format("", _conn, message), do: message
end
