defmodule Plug.AccessLog.Formatter.RequestHeaderTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.Formatter

  test "%{VARNAME}i" do
    header = "X-Test-Header"
    value  = "test value for %i"
    conn   =
         conn(:get, "/")
      |> put_req_header(header |> String.downcase, value)

    assert value == Formatter.format("%{#{ header }}i", conn)
    assert "-"   == Formatter.format("%{X-Unknown-Header}i", conn)
  end
end
