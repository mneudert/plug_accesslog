defmodule Plug.AccessLog.FileHandling.SystemEnvTest do
  use ExUnit.Case, async: true
  use Plug.Test

  defmodule Logfiles do
    def path, do: Path.expand("../../../logs/plug_filehandling_system_env.log", __DIR__)
    def var, do: "PLUG_ACCESSLOG_TEST_PATH"
  end

  test "logfile system environment configuration" do
    System.put_env(Logfiles.var(), Logfiles.path())

    # compilation done here to ensure system variable is set!
    defmodule Router do
      use Plug.Router

      plug Plug.AccessLog, file: {:system, Logfiles.var()}

      plug :match
      plug :dispatch

      get "/", do: send_resp(conn, 200, "OK")
    end

    # actual test
    conn(:get, "/") |> Router.call([])

    :timer.sleep(50)

    assert File.exists?(Logfiles.path())
  end

  test "logfile system environment configuration (with default)" do
    System.delete_env(Logfiles.var())

    # compilation done here to ensure system variable is set!
    defmodule RouterDefaults do
      use Plug.Router

      plug Plug.AccessLog, file: {:system, Logfiles.var(), Logfiles.path()}

      plug :match
      plug :dispatch

      get "/", do: send_resp(conn, 200, "OK")
    end

    # actual test
    conn(:get, "/") |> RouterDefaults.call([])

    :timer.sleep(50)

    assert File.exists?(Logfiles.path())
  end
end
