defmodule Plug.AccessLog.LogfilesTest do
  use ExUnit.Case, async: true

  alias Plug.AccessLog.Logfiles

  test "get implicitly opens logfile" do
    logfile =
         [ __DIR__, "../../logs/plug_accesslog_logfiles_implicit.log" ]
      |> Path.join()
      |> Path.expand()

    assert logfile |> Logfiles.get() |> is_pid()
  end

  test "logfile opened only once" do
    logfile =
         [ __DIR__, "../../logs/plug_accesslog_logfiles_once.log" ]
      |> Path.join()
      |> Path.expand()

    log_device = Logfiles.open(logfile)
    new_device = Logfiles.open(logfile)

    assert log_device == new_device
    assert log_device == Logfiles.get(logfile)
  end
end
