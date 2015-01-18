defmodule Plug.AccessLog.FormatterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.Formatter

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

  test "%r" do
    conn = conn(:get, "/plug/path")

    assert "GET /plug/path HTTP/1.1" == Formatter.format("%r", conn)
  end

  test "%>s" do
    conn = conn(:get, "/")
    conn = %{ conn | status: 200 }

    assert "200" == Formatter.format("%>s", conn)
  end
end
