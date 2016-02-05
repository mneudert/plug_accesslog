defmodule Plug.AccessLog.FileHandling.RecreationTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule Logfile do
    def path do
      [ __DIR__, "../../../logs/plug_filehandling_recreation.log" ]
      |> Path.join()
      |> Path.expand()
    end
  end

  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog, file: Logfile.path

    plug :match
    plug :dispatch

    get "/first", do: send_resp(conn, 200, "OK")
    get "/second", do: send_resp(conn, 200, "OK")
  end


  test "log recreation" do
    # first request
    conn(:get, "/first") |> Router.call([])
    :timer.sleep(250)

    assert Logfile.path |> File.exists?
    assert Logfile.path |> File.read! |> String.contains?("first")
    refute Logfile.path |> File.read! |> String.contains?("second")

    # recreate file
    File.rm! Logfile.path
    File.touch! Logfile.path

    # second request
    conn(:get, "/second") |> Router.call([])
    :timer.sleep(250)

    refute Logfile.path |> File.read! |> String.contains?("first")
    assert Logfile.path |> File.read! |> String.contains?("second")
  end
end