defmodule Plug.AccessLog.DefaultFormatter.ResponseHeaderTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.DefaultFormatter

  test "%{VARNAME}o" do
    header = "X-Test-Header"
    value  = "test value for %o"
    conn   =
         conn(:get, "/")
      |> put_resp_header(header |> String.downcase, value)

    assert value == DefaultFormatter.format("%{#{ header }}o", conn)
    assert "-"   == DefaultFormatter.format("%{X-Unknown-Header}o", conn)
  end
end
