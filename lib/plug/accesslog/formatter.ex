defmodule Plug.AccessLog.Formatter do
  @moduledoc """
  Log message formatter.
  """

  alias Plug.AccessLog.Formatter

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
  - `%a` - Remote IP-address
  - `%b` - Size of response in bytes. Outputs "-" when no bytes are sent.
  - `%B` - Size of response in bytes. Outputs "0" when no bytes are sent.
  - `%{VARNAME}C` - Cookie sent by the client
  - `%h` - Remote hostname
  - `%{VARNAME}i` - Header line sent by the client
  - `%l` - Remote logname
  - `%m` - Request method
  - `%{VARNAME}o` - Header line sent by the server
  - `%r` - First line of HTTP request
  - `%>s` - Response status code
  - `%t` - Time the request was received in the format `[10/Jan/2015:14:46:18 +0100]`
  - `%T` - Time taken to serve the request (full seconds)
  - `%u` - Remote user
  - `%U` - URL path requested (without query string)
  - `%v` - Server name
  - `%V` - Server name (canonical)

  **Note for %b and %B**: To determine the size of the response the
  "Content-Length" will be inspected and, if available, returned
  unverified. If the header is not present the response body will be
  inspected using `byte_size/1`.

  **Note for %h**: The hostname will always be the ip of the client (same as `%a`).

  **Note for %l**: Always a dash ("-").

  **Note for %r**: For now the http version is always logged as "HTTP/1.1",
  regardless of the true http version.

  **Note for %T**: Rounding happens, so "0.6 seconds" will be reported as "1 second".

  **Note for %V**: Alias for `%v`.
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
    log("", conn, format)
  end


  # Internal construction methods

  defp log(message, _conn, ""), do: message

  defp log(message, conn, << "%%", rest :: binary >>) do
    message <> "%"
    |> log(conn, rest)
  end

  defp log(message, conn, << "%a", rest :: binary >>) do
    message
    |> Formatter.RemoteIPAddress.append(conn)
    |> log(conn, rest)
  end

  defp log(message, conn, << "%b", rest :: binary >>) do
    message
    |> Formatter.ResponseBytes.append(conn, "-")
    |> log(conn, rest)
  end

  defp log(message, conn, << "%B", rest :: binary >>) do
    message
    |> Formatter.ResponseBytes.append(conn, "0")
    |> log(conn, rest)
  end

  defp log(message, conn, << "%h", rest :: binary >>) do
    message
    |> Formatter.RemoteIPAddress.append(conn)
    |> log(conn, rest)
  end

  defp log(message, conn, << "%l", rest :: binary >>) do
    message <> "-"
    |> log(conn, rest)
  end

  defp log(message, conn, << "%m", rest :: binary >>) do
    message <> conn.method
    |> log(conn, rest)
  end

  defp log(message, conn, << "%r", rest :: binary >>) do
    message
    |> Formatter.RequestLine.append(conn)
    |> log(conn, rest)
  end

  defp log(message, conn, << "%>s", rest :: binary >>) do
    message <> to_string(conn.status)
    |> log(conn, rest)
  end

  defp log(message, conn, << "%t", rest :: binary >>) do
    message
    |> Formatter.RequestTime.append(conn)
    |> log(conn, rest)
  end

  defp log(message, conn, << "%T", rest :: binary >>) do
    message
    |> Formatter.RequestServingTime.append(conn)
    |> log(conn, rest)
  end

  defp log(message, conn, << "%u", rest :: binary >>) do
    message
    |> Formatter.RemoteUser.append(conn)
    |> log(conn, rest)
  end

  defp log(message, conn, << "%U", rest :: binary >>) do
    message
    |> Formatter.RequestPath.append(conn)
    |> log(conn, rest)
  end

  defp log(message, conn, << "%v", rest :: binary >>) do
    message <> conn.host
    |> log(conn, rest)
  end

  defp log(message, conn, << "%V", rest :: binary >>) do
    message <> conn.host
    |> log(conn, rest)
  end

  defp log(message, conn, << "%{", rest :: binary >>) do
    [ varname, rest ] = rest |> String.split("}", parts: 2)

    << vartype :: binary-1, rest :: binary >> = rest

    message = case vartype do
      "C" -> Formatter.RequestCookie.append(message, conn, varname)
      "i" -> Formatter.RequestHeader.append(message, conn, varname)
      "o" -> Formatter.ResponseHeader.append(message, conn, varname)
      _   -> message <> "-"
    end

    log(message, conn, rest)
  end

  defp log(message, conn, << char, rest :: binary >>) do
    message <> << char >>
    |> log(conn, rest)
  end
end
