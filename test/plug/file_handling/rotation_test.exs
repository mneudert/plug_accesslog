defmodule Plug.FileHandling.RotationTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule Logfiles do
    def original do
      [ __DIR__, "../../logs/plug_filehandling_rotation.log" ]
      |> Path.join()
      |> Path.expand()
    end

    def rotated, do: original <> ".rotated.log"
  end

  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog, file: Logfiles.original

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 200, "OK")
  end


  test "log rotation" do
    refute File.exists?(Logfiles.original)
    refute File.exists?(Logfiles.rotated)

    # initial request
    conn(:get, "/") |> Router.call([])
    :timer.sleep(250)

    assert File.exists?(Logfiles.original)

    # rotate logfile
    :file.rename(Logfiles.original, Logfiles.rotated)

    refute File.exists?(Logfiles.original)
    assert File.exists?(Logfiles.rotated)

    # second request
    conn(:get, "/") |> Router.call([])
    :timer.sleep(250)

    assert File.exists?(Logfiles.original)
    assert File.exists?(Logfiles.rotated)
  end
end