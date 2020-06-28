defmodule Plug.AccessLog do
  @moduledoc """
  AccessLog Plug
  """

  use Timex

  import Plug.Conn

  alias Plug.AccessLog.Formatter
  alias Plug.AccessLog.WAL

  @behaviour Plug

  def init(opts) do
    opts = Enum.into(opts, %{})

    case opts do
      %{file: {:system, var, default}} -> %{opts | file: System.get_env(var) || default}
      %{file: {:system, var}} -> %{opts | file: System.get_env(var)}
      _ -> opts
    end
  end

  def call(conn, opts) do
    conn
    |> put_private(:plug_accesslog_localtime, Timex.local())
    |> put_private(:plug_accesslog_timestamp, :os.timestamp())
    |> register_before_send(&log(&1, opts))
  end

  @doc """
  Logs the request.

  If the target logfile could not be opened the message
  will be silently ignored.
  """
  @spec log(Plug.Conn.t(), map) :: Plug.Conn.t()
  def log(conn, %{dontlog: dontlogfun} = opts) do
    case dontlogfun.(conn) do
      true -> conn
      false -> log(conn, Map.delete(opts, :dontlog))
    end
  end

  def log(conn, %{fun: logfun} = opts) do
    opts[:format]
    |> Formatter.format(conn, opts[:formatters])
    |> logfun.()

    conn
  end

  def log(conn, %{file: logfile} = opts) do
    opts[:format]
    |> Formatter.format(conn, opts[:formatters])
    |> WAL.log(logfile)

    conn
  end
end
