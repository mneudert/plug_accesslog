defmodule Plug.AccessLog.Formatter do
  @moduledoc """
  Formatting pipeline.
  """

  use Behaviour


  # Pipeline interface

  @formats [
    agent:          "%{User-Agent}i",
    clf:            "%h %l %u %t \"%r\" %>s %b",
    clf_vhost:      "%v %h %l %u %t \"%r\" %>s %b",
    combined:       "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"",
    combined_vhost: "%v %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"",
    referer:        "%{Referer}i -> %U"
  ]

  @doc """
  Formats a log message.

  The `:default` format is `:clf`.
  """
  @spec format(atom | String.t, Plug.Conn.t) :: String.t
  def format(nil,      conn), do: format(:clf, conn)
  def format(:default, conn), do: format(:clf, conn)

  def format(format, conn) when is_atom(format) do
    format(@formats[format], conn)
  end

  def format(format, conn) when is_binary(format) do
    Plug.AccessLog.DefaultFormatter.format(format, conn)
  end


  # Behaviour callbacks

  @doc """
  Formats a log message.
  """
  defcallback format(format :: String.t, conn :: Plug.Conn.t) :: String.t
end
