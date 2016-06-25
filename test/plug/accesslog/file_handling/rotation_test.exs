defmodule Plug.AccessLog.FileHandling.RotationTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule Logfiles do
    def original do
      [ __DIR__, "../../../logs/plug_filehandling_rotation.log" ]
      |> Path.join()
      |> Path.expand()
    end

    def rotated, do: original() <> ".rotated.log"
  end

  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog, file: Logfiles.original()

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 200, "OK")
  end


  test "log rotation" do
    original = Logfiles.original()
    rotated  = Logfiles.rotated()

    refute File.exists?(original)
    refute File.exists?(rotated)

    # initial request
    conn(:get, "/") |> Router.call([])
    :timer.sleep(50)

    assert File.exists?(original)

    # rotate logfile
    :file.rename(original, rotated)

    refute File.exists?(original)
    assert File.exists?(rotated)

    # second request
    conn(:get, "/") |> Router.call([])
    :timer.sleep(50)

    assert File.exists?(original)
    assert File.exists?(rotated)
  end
end
