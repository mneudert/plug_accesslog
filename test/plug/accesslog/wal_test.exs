defmodule Plug.AccessLog.WALTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.WAL

  test "order of logmessages" do
    logfile = "plug_accesslog_wal_test"
    msg_1   = "first message"
    msg_2   = "second message"

    :ok = WAL.log(msg_1, logfile)
    :ok = WAL.log(msg_2, logfile)

    assert [ msg_1, msg_2 ] == WAL.flush(logfile)
  end
end
