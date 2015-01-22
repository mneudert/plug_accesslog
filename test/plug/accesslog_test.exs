defmodule Plug.AccessLogTest do
  use ExUnit.Case, async: true
  use Plug.Test

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
    conn(:get, "/") |> Router.call(@opts)

    regex = ~r/127.0.0.1 - - \[.+\] "GET \/ HTTP\/1.1" 200 2/
    log   = Router.logfile |> File.read! |> String.strip()

    assert Regex.match?(regex, log)
  end
end
