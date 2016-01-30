defmodule Plug.AccessLog do
  @moduledoc """
  AccessLog Plug
  """

  import Plug.Conn

  alias Plug.AccessLog.Formatter
  alias Plug.AccessLog.WAL
  alias Plug.AccessLog.Writer

  @behaviour Plug

  def init(opts) do
    opts = opts |> Enum.into(%{})

    :ok = case opts[:file] do
      nil     -> :ok
      logfile -> Writer.register_file(logfile)
    end

    opts
  end

  def call(conn, opts) do
    conn
    |> put_private(:plug_accesslog, private_data)
    |> register_before_send( &log(&1, opts) )
  end

  defp private_data do
    %{ local_time: :calendar.local_time(),
       timestamp:  :os.timestamp() }
  end


  @doc """
  Logs the request.

  If the target logfile could not be openend the message
  will be silently ignored.
  """
  @spec log(Plug.Conn.t, map) :: Plug.Conn.t
  def log(conn, %{ dontlog: dontlogfun } = opts) do
    case dontlogfun.(conn) do
      true  -> conn
      false -> log(conn, Map.delete(opts, :dontlog))
    end
  end

  def log(conn, %{ fun: logfun } = opts) do
    opts[:format]
    |> Formatter.format(conn, opts[:formatters])
    |> logfun.()

    conn
  end

  def log(conn, %{ file: logfile } = opts) do
    opts[:format]
    |> Formatter.format(conn, opts[:formatters])
    |> WAL.log(logfile)

    conn
  end
end
