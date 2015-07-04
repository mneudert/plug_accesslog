defmodule Plug.AccessLog.Writer.WatcherTest do
  use ExUnit.Case, async: false
  use Plug.Test


  defmodule Logfile do
    def path do
      [ __DIR__, "../../../logs/plug_accesslog_writer_watcher.log" ]
      |> Path.join()
      |> Path.expand()
    end
  end

  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog, file: Logfile.path

    plug :match
    plug :dispatch

    get "/first",  do: send_resp(conn, 200, "OK")
    get "/second", do: send_resp(conn, 200, "OK")
  end


  test "self-restarting writer" do
    # first request
    conn(:get, "/first") |> Router.call([])
    :timer.sleep(100)

    assert Logfile.path |> File.exists?
    assert Logfile.path |> File.read! |> String.contains?("first")
    refute Logfile.path |> File.read! |> String.contains?("second")

    # kill writer
    old = Process.whereis(Plug.AccessLog.Writer)

    GenEvent.stop(Plug.AccessLog.Writer)
    :timer.sleep(100)

    new = Process.whereis(Plug.AccessLog.Writer)

    refute old == new
    assert is_pid(new)

    # second request
    conn(:get, "/second") |> Router.call([])
    :timer.sleep(100)

    assert Logfile.path |> File.read! |> String.contains?("first")
    assert Logfile.path |> File.read! |> String.contains?("second")
  end
end
