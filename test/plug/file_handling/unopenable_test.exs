defmodule Plug.FileHandling.UnopenableTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.Logfiles

  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog, file: ".."

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 200, "OK")
  end

  test "unopenable files are ignored" do
    conn = conn(:get, "/") |> Router.call([])

    assert nil == Logfiles.get("..")
    assert 200 == conn.status
  end
end