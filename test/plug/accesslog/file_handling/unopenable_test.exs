defmodule Plug.AccessLog.FileHandling.UnopenableTest do
  use ExUnit.Case, async: false
  use Plug.Test

  import ExUnit.CaptureLog

  alias Plug.AccessLog.Logfiles

  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog, file: ".."

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 200, "OK")
  end

  test "unopenable files are ignored" do
    log =
      capture_log(fn ->
        conn(:get, "/") |> Router.call([])
        :timer.sleep(50)

        refute Logfiles.get("..")
      end)

    assert String.contains?(log, ":eisdir")
  end

  test "replacement with unopenable logfile" do
    logfile = Path.expand("../../../logs/logfiles_replacement/error.log", __DIR__)
    logdir = Path.dirname(logfile)

    File.rm_rf!(logdir)
    File.mkdir!(logdir)
    File.touch!(logfile)

    assert self() == Logfiles.set(logfile, self())

    File.rm_rf!(logdir)

    log =
      capture_log(fn ->
        refute Logfiles.get(logfile)
      end)

    assert String.contains?(log, ":enoent")
  end
end
