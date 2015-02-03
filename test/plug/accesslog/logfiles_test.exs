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

  test "replacement of logfiles" do
    logfile =
         [ __DIR__, "../../logs/plug_accesslog_logfiles_replace.log" ]
      |> Path.join()
      |> Path.expand()

    log_device = Logfiles.open(logfile)
    new_device = Logfiles.replace(logfile, :stdio)

    refute log_device == new_device
    refute log_device == Logfiles.get(logfile)
    assert new_device == Logfiles.get(logfile)
  end

  test "logfile device automatically restored in case of crash" do
    logfile =
         [ __DIR__, "../../logs/plug_accesslog_logfiles_restore.log" ]
      |> Path.join()
      |> Path.expand()

    old_pid = logfile |> Logfiles.get()

    assert Process.exit(old_pid, :kill)
    refute Process.alive?(old_pid)

    new_pid = logfile |> Logfiles.get()

    assert Process.alive?(new_pid)
    refute old_pid == new_pid
  end
end
