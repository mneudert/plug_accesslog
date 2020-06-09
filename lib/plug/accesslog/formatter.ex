defmodule Plug.AccessLog.Formatter do
  @moduledoc """
  Formatting pipeline.
  """

  alias Plug.AccessLog.DefaultFormatter

  @formats [
    agent: "%{User-Agent}i",
    clf: "%h %l %u %t \"%r\" %>s %b",
    clf_vhost: "%v %h %l %u %t \"%r\" %>s %b",
    combined: "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"",
    combined_vhost: "%v %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"",
    referer: "%{Referer}i -> %U"
  ]

  @doc """
  Formats a log message.

  The `:default` format is `:clf`.
  """
  @spec format(atom | String.t(), Plug.Conn.t(), list) :: String.t()
  def format(nil, conn, formatters), do: format(:clf, conn, formatters)
  def format(:default, conn, formatters), do: format(:clf, conn, formatters)

  def format(format, conn, formatters) when is_atom(format) do
    format(@formats[format], conn, formatters)
  end

  def format(msg, conn, nil), do: format(msg, conn, [DefaultFormatter])

  def format(msg, _, []), do: msg

  def format(msg, conn, [formatter | formatters]) do
    msg
    |> formatter.format(conn)
    |> format(conn, formatters)
  end

  @doc """
  Formats a log message.
  """
  @callback format(format :: String.t(), conn :: Plug.Conn.t()) :: String.t()
end
