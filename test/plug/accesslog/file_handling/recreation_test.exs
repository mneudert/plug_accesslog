defmodule Plug.AccessLog.FileHandling.RecreationTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule Logfile do
    def path, do: Path.expand("../../../logs/plug_filehandling_recreation.log", __DIR__)
  end

  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog, file: Logfile.path()

    plug :match
    plug :dispatch

    get "/first", do: send_resp(conn, 200, "OK")
    get "/second", do: send_resp(conn, 200, "OK")
  end

  test "log recreation" do
    # first request
    conn(:get, "/first") |> Router.call([])
    :timer.sleep(50)

    logfile = Logfile.path()

    assert File.exists?(logfile)

    logcontents = File.read!(logfile)

    assert String.contains?(logcontents, "first")
    refute String.contains?(logcontents, "second")

    # recreate file
    File.rm!(logfile)
    File.touch!(logfile)

    # second request
    conn(:get, "/second") |> Router.call([])
    :timer.sleep(50)

    logcontents = File.read!(logfile)

    refute String.contains?(logcontents, "first")
    assert String.contains?(logcontents, "second")
  end
end
