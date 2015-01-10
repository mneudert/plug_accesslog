defmodule Plug.AccessLogTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 200, "OK")
  end

  @opts Router.init([])

  test "returns 200" do
    conn = conn(:get, "/") |> Router.call(@opts)

    assert conn.status == 200
  end
end
