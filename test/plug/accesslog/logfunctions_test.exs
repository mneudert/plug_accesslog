defmodule Plug.AccessLog.LogfunctionsTest do
  use ExUnit.Case, async: false
  use Plug.Test

  import ExUnit.CaptureIO


  defmodule LogProxy do
    def log(msg), do: Logger.log(:info, msg)
  end

  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog, format: "logger fun", fun: &LogProxy.log/1

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 200, "OK")
  end


  test "functions log requests" do
    log = capture_io :user, fn ->
      conn(:get, "/") |> Router.call([])
      Logger.flush()
    end

    assert String.contains?(log, "logger fun")
  end
end