defmodule Plug.AccessLog.Formatter.ResponseHeaderTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.Formatter

  test "%{VARNAME}o" do
    header = "X-Test-Header"
    value  = "test value for %o"
    conn   =
         conn(:get, "/")
      |> put_resp_header(header |> String.downcase, value)

    assert value == Formatter.format("%{#{ header }}o", conn)
    assert "-"   == Formatter.format("%{X-Unknown-Header}o", conn)
  end
end
