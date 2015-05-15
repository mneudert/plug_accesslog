defmodule Plug.AccessLog do
  @moduledoc """
  AccessLog Plug
  """

  import Plug.Conn

  alias Plug.AccessLog.Formatter
  alias Plug.AccessLog.Logfiles
  alias Plug.AccessLog.Writer

  @behaviour Plug

  def init(opts), do: opts |> Enum.into(%{})

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
  @spec log(conn :: Plug.Conn.t, opts :: map) :: Plug.Conn.t
  def log(conn, %{ dontlog: dontlogfun } = opts) do
    case dontlogfun.(conn) do
      true  -> conn
      false -> log(conn, Map.delete(opts, :dontlog))
    end
  end

  def log(conn, %{ fun: logfun } = opts) do
    opts[:format]
    |> Formatter.format(conn)
    |> logfun.()

    conn
  end

  def log(conn, %{ file: logfile } = opts) do
    logfile |> Logfiles.get() |> maybe_log(conn, opts)
  end


  defp maybe_log(nil,    conn, _opts), do: conn
  defp maybe_log(device, conn,  opts)  do
    opts[:format]
    |> Formatter.format(conn)
    |> Writer.write(device)

    conn
  end
end
