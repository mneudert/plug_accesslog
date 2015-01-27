defmodule Plug.AccessLog.FormatterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Timex

  alias Plug.AccessLog.Formatter

  test "no format means default format" do
    datetime = :calendar.local_time()
    conn     = conn(:get, "/") |> put_private(:plug_accesslog, datetime)

    assert Formatter.format(nil, conn) == Formatter.format(:default, conn)
  end


  test "%b" do
    conn = conn(:get, "/")

    # no content length, no response body
    assert "-" == Formatter.format("%b", conn)

    # response body
    conn = %{ conn | resp_body: "Hello, World!" }

    assert "13" == Formatter.format("%b", conn)

    # content length header
    conn = conn |> put_resp_header("Content-Length", "227")

    assert "227" == Formatter.format("%b", conn)
  end

  test "%h" do
    conn = conn(:get, "/")

    assert "127.0.0.1" == Formatter.format("%h", conn)
  end

  test "%{VARNAME}i" do
    header = "X-Test-Header"
    value  = "test value for %i"
    conn   = conn(:get, "/") |> put_req_header(header, value)

    assert value == Formatter.format("%{#{ header }}i", conn)
    assert "-"   == Formatter.format("%{X-Unknown-Header}i", conn)
  end

  test "%l" do
    assert "-" == Formatter.format("%l", nil)
  end

  test "%r" do
    conn = conn(:get, "/plug/path")

    assert "GET /plug/path HTTP/1.1" == Formatter.format("%r", conn)
  end

  test "%>s" do
    conn = conn(:get, "/")
    conn = %{ conn | status: 200 }

    assert "200" == Formatter.format("%>s", conn)
  end

  test "%t" do
    datetime  = {{ 2015, 01, 10 }, { 14, 46, 18 }}
    conn      = conn(:get, "/") |> put_private(:plug_accesslog, datetime)
    formatted =
         datetime
      |> Date.from(:local)
      |> DateFormat.format!("[%d/%b/%Y:%H:%M:%S %z]", :strftime)

    assert formatted == Formatter.format("%t", conn)
  end

  test "%u" do
    user        = "ex_unit"
    credentials = Base.encode64("#{ user }:some_password")

    empty      = conn(:get, "/")
    valid      = empty |> put_req_header("Authorization", "Basic #{ credentials }")
    incomplete = empty |> put_req_header("Authorization", "Basic #{ Base.encode64(user) }")
    garbage    = empty |> put_req_header("Authorization", "Basic garbage")

    assert "-"  == Formatter.format("%u", empty)
    assert user == Formatter.format("%u", valid)
    assert "-"  == Formatter.format("%u", incomplete)
    assert "-"  == Formatter.format("%u", garbage)
  end

  test "%v" do
    host = "plug.access.log"
    conn = conn(:get, "/") |> Map.put(:host, host)

    assert host == Formatter.format("%v", conn)
  end


  test "invalid configurable type" do
    assert "-" == Formatter.format("%{ignored}_", nil)
  end
end
