defmodule Plug.AccessLog.DefaultFormatter.EnvironmentTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.DefaultFormatter

  test "%{VARNAME}e" do
    var = "PLUG_ACCESSLOG_TEST"
    value = "test_env for plug_accesslog"
    conn = conn(:get, "/")

    unknown = "PLUG_ACCESSLOG_UNKNOWN"

    System.put_env(var, value)

    assert value == DefaultFormatter.format("%{#{var}}e", conn)
    assert "" == DefaultFormatter.format("%{#{unknown}}e", conn)
  end
end
