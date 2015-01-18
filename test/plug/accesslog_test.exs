defmodule Plug.AccessLogTest do
  use ExUnit.Case, async: false
  use Plug.Test

  import ExUnit.CaptureIO

  alias Plug.AccessLog.Logfiles

  defmodule Router do
    use Plug.Router

    @logfile [ __DIR__, "../logs/plug_accesslog.log" ] |> Path.join() |> Path.expand()

    plug Plug.AccessLog, file: @logfile

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 200, "OK")

    def logfile, do: @logfile
  end

  @opts Router.init([])

  test "request writes log entry" do
    Logfiles.replace(Router.logfile, :stdio)

    regex = ~r/127.0.0.1 - - \[.+\] "GET \/ HTTP\/1.1" 200 2/
    log   = capture_io :stdio, fn ->
      conn(:get, "/") |> Router.call(@opts)
    end

    assert Regex.match?(regex, String.strip(log))
  end
end
