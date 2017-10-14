defmodule Plug.AccessLog.DefaultFormatterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.DefaultFormatter

  test "%%" do
    assert "%" == DefaultFormatter.format("%%", nil)
  end

  test "%l" do
    assert "-" == DefaultFormatter.format("%l", nil)
  end

  test "%m" do
    get = conn(:get, "/")
    head = conn(:head, "/")
    post = conn(:post, "/")

    assert "GET" == DefaultFormatter.format("%m", get)
    assert "HEAD" == DefaultFormatter.format("%m", head)
    assert "POST" == DefaultFormatter.format("%m", post)
  end

  test "%P" do
    conn = conn(:get, "/")

    assert inspect(conn.owner) == DefaultFormatter.format("%P", conn)
  end

  test "%>s" do
    conn = conn(:get, "/")
    conn = %{conn | status: 200}

    assert "200" == DefaultFormatter.format("%>s", conn)
  end

  test "%v" do
    host = "plug.access.log"
    conn = conn(:get, "/") |> Map.put(:host, host)

    assert host == DefaultFormatter.format("%v", conn)
  end

  test "%V" do
    host = "plug.log.access"
    conn = conn(:get, "/") |> Map.put(:host, host)

    assert host == DefaultFormatter.format("%V", conn)
  end

  test "invalid configurable type" do
    assert "-" == DefaultFormatter.format("%{ignored}_", nil)
  end
end
