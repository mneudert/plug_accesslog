defmodule Plug.FileHandling.UnopenableTest do
  use ExUnit.Case, async: false
  use Plug.Test

  import ExUnit.CaptureIO

  alias Plug.AccessLog.Logfiles


  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog, file: ".."

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 200, "OK")
  end


  test "unopenable files are ignored" do
    log = capture_io :user, fn ->
      conn = conn(:get, "/") |> Router.call([])

      assert nil == Logfiles.get("..")
      assert 200 == conn.status

      Logger.flush()
    end

    assert String.contains?(log, ":eisdir")
  end

  test "replacement with unopenable logfile" do
    logfile =
         [ __DIR__, "../../logs/logfiles_replacement/error.log" ]
      |> Path.join()
      |> Path.expand()

    logfile |> Path.dirname |> File.rm_rf!
    logfile |> Path.dirname |> File.mkdir!
    logfile |> File.touch!

    assert self == Logfiles.set(logfile, self)

    logfile |> Path.dirname |> File.rm_rf!

    log = capture_io :user, fn ->
      assert nil == Logfiles.get(logfile)

      Logger.flush()
    end

    assert String.contains?(log, ":enoent")
  end
end