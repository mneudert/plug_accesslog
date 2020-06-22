defmodule Plug.AccessLog.DontlogTest do
  use ExUnit.Case, async: false
  use Plug.Test

  import ExUnit.CaptureLog

  defmodule DontLog do
    require Logger

    def log(msg), do: Logger.log(:info, msg)

    def maybe_skip(conn), do: "/dontlog" == conn.request_path
  end

  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog,
      dontlog: &DontLog.maybe_skip/1,
      format: "dontlog equals false",
      fun: &DontLog.log/1

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 200, "OK")
    get "/dontlog", do: send_resp(conn, 200, "OK")
  end

  test "dontlog true" do
    log =
      capture_log(fn ->
        conn(:get, "/dontlog") |> Router.call([])
      end)

    assert "" = log
  end

  test "dontlog false" do
    log =
      capture_log(fn ->
        conn(:get, "/") |> Router.call([])
      end)

    assert String.contains?(log, "dontlog equals false")
  end
end
