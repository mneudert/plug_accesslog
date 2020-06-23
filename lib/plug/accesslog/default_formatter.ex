defmodule Plug.AccessLog.DefaultFormatter do
  @moduledoc """
  Default log message formatter.
  """

  alias Plug.AccessLog.DefaultFormatter
  alias Plug.AccessLog.Formatter

  @behaviour Formatter

  @doc """
  Formats a log message.

  The following formatting directives are available:

  - `%%` - Percentage sign
  - `%a` - Remote IP-address
  - `%b` - Size of response in bytes. Outputs "-" when no bytes are sent.
  - `%B` - Size of response in bytes. Outputs "0" when no bytes are sent.
  - `%{VARNAME}C` - Cookie sent by the client
  - `%D` - Time taken to serve the request (microseconds)
  - `%{VARNAME}e` - Environment variable contents
  - `%h` - Remote hostname
  - `%{VARNAME}i` - Header line sent by the client
  - `%l` - Remote logname
  - `%m` - Request method
  - `%M` - Time taken to serve the request (milliseconds)
  - `%{VARNAME}o` - Header line sent by the server
  - `%P` - The process ID that serviced the request
  - `%q` - Query string (prepended with "?" or empty string)
  - `%r` - First line of HTTP request
  - `%>s` - Response status code
  - `%t` - Time the request was received in the format `[10/Jan/2015:14:46:18 +0100]`
  - `%T` - Time taken to serve the request (full seconds)
  - `%{UNIT}T` - Time taken to serve the request in the given UNIT
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

  **Note for %T**: Rounding happens, so "0.6 seconds" will be reported as "1 second".

  **Note for %{UNIT}T**: Available units are `s` for seconds (same as `%T`),
  `ms` for milliseconds (same as `M`) and `us` for microseconds (same as `%D`).

  **Note for %V**: Alias for `%v`.
  """
  @impl Formatter
  def format(format, conn), do: log([], conn, format)

  defp log(message, _conn, ""), do: message |> Enum.reverse() |> IO.iodata_to_binary()

  defp log(message, conn, <<"%%", rest::binary>>) do
    ["%" | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%a", rest::binary>>) do
    [DefaultFormatter.RemoteIPAddress.format(conn) | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%b", rest::binary>>) do
    [DefaultFormatter.ResponseBytes.format(conn, "-") | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%B", rest::binary>>) do
    [DefaultFormatter.ResponseBytes.format(conn, "0") | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%D", rest::binary>>) do
    [DefaultFormatter.RequestServingTime.format(conn, :microseconds) | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%h", rest::binary>>) do
    [DefaultFormatter.RemoteIPAddress.format(conn) | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%l", rest::binary>>) do
    ["-" | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%m", rest::binary>>) do
    [conn.method | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%M", rest::binary>>) do
    [DefaultFormatter.RequestServingTime.format(conn, :milliseconds) | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%P", rest::binary>>) do
    [inspect(conn.owner) | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%q", rest::binary>>) do
    [DefaultFormatter.QueryString.format(conn) | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%r", rest::binary>>) do
    [DefaultFormatter.RequestLine.format(conn) | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%>s", rest::binary>>) do
    [to_string(conn.status) | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%t", rest::binary>>) do
    [DefaultFormatter.RequestTime.format(conn) | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%T", rest::binary>>) do
    [DefaultFormatter.RequestServingTime.format(conn, :seconds) | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%u", rest::binary>>) do
    [DefaultFormatter.RemoteUser.format(conn) | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%U", rest::binary>>) do
    [DefaultFormatter.RequestPath.format(conn) | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%v", rest::binary>>) do
    [conn.host | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%V", rest::binary>>) do
    [conn.host | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<"%{", rest::binary>>) do
    [var, rest] = String.split(rest, "}", parts: 2)

    <<vartype::binary-1, rest::binary>> = rest

    append =
      case vartype do
        "C" -> DefaultFormatter.RequestCookie.format(conn, var)
        "e" -> DefaultFormatter.Environment.format(conn, var)
        "i" -> DefaultFormatter.RequestHeader.format(conn, var)
        "o" -> DefaultFormatter.ResponseHeader.format(conn, var)
        "T" -> DefaultFormatter.RequestServingTime.format(conn, var)
        _ -> "-"
      end

    [append | message]
    |> log(conn, rest)
  end

  defp log(message, conn, <<char, rest::binary>>) do
    [<<char>> | message]
    |> log(conn, rest)
  end
end
