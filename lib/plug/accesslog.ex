defmodule Plug.AccessLog do
  @moduledoc """
  AccessLog Plug
  """

  import Plug.Conn

  alias Plug.AccessLog.Formatter
  alias Plug.AccessLog.Logfiles
  alias Plug.AccessLog.Writer

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, opts) do
    conn
    |> put_private(:plug_accesslog, :calendar.local_time())
    |> register_before_send( &log(&1, opts) )
  end

  @doc """
  Logs the request.

  If the target logfile could not be openend the message
  will be silently ignored.
  """
  @spec log(conn :: Plug.Conn.t, opts :: Keyword.t) :: :ok
  def log(conn, opts) do
    opts[:file] |> Logfiles.get() |> maybe_log(conn, opts)
  end

  defp maybe_log(nil,    conn, _opts), do: conn
  defp maybe_log(device, conn,  opts)  do
    opts[:format]
    |> Formatter.format(conn)
    |> Writer.write(device)

    conn
  end
end
