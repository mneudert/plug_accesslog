defmodule Plug.AccessLog.Formatter do
  @moduledoc """
  Log message formatter.
  """

  use Timex

  import Plug.Conn

  @format_agent "%{User-Agent}i"
  @format_clf "%h %l %u %t \"%r\" %>s %b"
  @format_clf_vhost "%v " <> @format_clf
  @format_combined "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\""
  @format_combined_vhost "%v " <> @format_combined
  @format_referer "%{Referer}i -> %U"

  @doc """
  Formats a log message.

  The `:default` format is `:clf`.

  The following formatting directives are available:

  - `%%` - Percentage sign
  - `%b` - Size of response in bytes
  - `%h` - Remote hostname
  - `%{VARNAME}i` - Header line sent by the client
  - `%l` - Remote logname
  - `%r` - First line of HTTP request
  - `%>s` - Response status code
  - `%t` - Time the request was received in the format `[10/Jan/2015:14:46:18 +0100]`
  - `%u` - Remote user
  - `%U` - URL path requested (without query string)
  - `%v` - Server name

  **Note for %b**: To determine the size of the response the "Content-Length"
  (exact case match required for now!) will be inspected and, if available,
  returned unverified. If the header is not present the response body will be
  inspected using `byte_size/1`.

  **Note for %h**: The hostname will always be the ip of the client.

  **Note for %l**: Always a dash ("-").

  **Note for %r**: For now the http version is always logged as "HTTP/1.1",
  regardless of the true http version.
  """
  @spec format(format :: atom | String.t, conn :: Plug.Conn.t) :: String.t
  def format(nil,      conn), do: format(:clf, conn)
  def format(:default, conn), do: format(:clf, conn)

  def format(:agent,          conn), do: format(@format_agent, conn)
  def format(:clf,            conn), do: format(@format_clf, conn)
  def format(:clf_vhost,      conn), do: format(@format_clf_vhost, conn)
  def format(:combined,       conn), do: format(@format_combined, conn)
  def format(:combined_vhost, conn), do: format(@format_combined_vhost, conn)
  def format(:referer,        conn), do: format(@format_referer, conn)

  def format(format, conn) when is_binary(format) do
    format(format, conn, "")
  end


  # Internal construction methods

  defp format(<< "%%", rest :: binary >>, conn, message) do
    format(rest, conn, message <> "%")
  end

  defp format(<< "%b", rest :: binary >>, conn, message) do
    content_length = case get_resp_header(conn, "Content-Length") do
      [ length ] -> length
      _          -> (conn.resp_body || "") |> to_string() |> byte_size()
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
    username = case get_req_header(conn, "Authorization") do
      [<< "Basic ", credentials :: binary >>] -> get_user(credentials)
      _ -> "-"
    end

    format(rest, conn, message <> username)
  end

  defp format(<< "%U", rest :: binary >>, conn, message) do
    format(rest, conn, message <> full_path(conn))
  end

  defp format(<< "%v", rest :: binary >>, conn, message) do
    format(rest, conn, message <> conn.host)
  end

  defp format(<< "%{", rest :: binary >>, conn, message) do
    [ varname, rest ] = rest |> String.split("}", parts: 2)

    << vartype :: binary-1, rest :: binary >> = rest

    varvalue = case vartype do
      "i" ->
        case get_req_header(conn, varname) do
          [ value ] -> value
          _         -> "-"
        end
      _ -> "-"
    end

    format(rest, conn, message <> varvalue)
  end

  defp format(<< char, rest :: binary >>, conn, message) do
    format(rest, conn, message <> << char >>)
  end

  defp format("", _conn, message), do: message


  # Internal helper methods

  defp get_user(credentials) do
    try do
      case parse_credentials(credentials) do
        [ user, _pass ] -> user
        _               -> "-"
      end
    rescue
      _ -> "-"
    end
  end

  defp parse_credentials(credentials) do
    credentials
    |> Base.decode64!()
    |> String.split(":")
  end
end
