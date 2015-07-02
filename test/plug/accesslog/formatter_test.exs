defmodule Plug.AccessLog.FormatterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.Formatter

  test "no format means default format" do
    datetime = :calendar.local_time()
    conn     =
         conn(:get, "/")
      |> put_private(:plug_accesslog, %{ local_time: datetime })

    assert Formatter.format(nil, conn) == Formatter.format(:default, conn)
  end


  test "%%" do
    assert "%" == Formatter.format("%%", nil)
  end

  test "%l" do
    assert "-" == Formatter.format("%l", nil)
  end

  test "%m" do
    get  = conn(:get, "/")
    head = conn(:head, "/")
    post = conn(:post, "/")

    assert "GET"  == Formatter.format("%m", get)
    assert "HEAD" == Formatter.format("%m", head)
    assert "POST" == Formatter.format("%m", post)
  end

  test "%>s" do
    conn = conn(:get, "/")
    conn = %{ conn | status: 200 }

    assert "200" == Formatter.format("%>s", conn)
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
