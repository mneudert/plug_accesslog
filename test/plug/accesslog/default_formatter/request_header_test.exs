defmodule Plug.AccessLog.DefaultFormatter.RequestHeaderTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.DefaultFormatter

  test "%{VARNAME}i" do
    header = "X-Test-Header"
    value  = "test value for %i"
    conn   =
         conn(:get, "/")
      |> put_req_header(header |> String.downcase, value)

    assert value == DefaultFormatter.format("%{#{ header }}i", conn)
    assert "-"   == DefaultFormatter.format("%{X-Unknown-Header}i", conn)
  end
end
