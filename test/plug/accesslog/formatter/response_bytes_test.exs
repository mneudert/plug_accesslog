defmodule Plug.AccessLog.Formatter.ResponseBytesTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.Formatter

  test "%b" do
    conn = conn(:get, "/")

    # no content length, no response body
    assert "-" == Formatter.format("%b", conn)

    # binary response body
    conn = %{ conn | resp_body: "Hello, World!" }

    assert "13" == Formatter.format("%b", conn)

    # charlist response body
    conn = %{ conn | resp_body: 'Hello, World!' }

    assert "13" == Formatter.format("%b", conn)

    # content length header
    conn = conn |> put_resp_header("content-length", "227")

    assert "227" == Formatter.format("%b", conn)
  end

  test "%B" do
    conn = conn(:get, "/")

    # no content length, no response body
    assert "0" == Formatter.format("%B", conn)

    # binary response body
    conn = %{ conn | resp_body: "Hello, World!" }

    assert "13" == Formatter.format("%B", conn)

    # charlist response body
    conn = %{ conn | resp_body: 'Hello, World!' }

    assert "13" == Formatter.format("%B", conn)

    # content length header (binary)
    conn = conn |> put_resp_header("content-length", "227")

    assert "227" == Formatter.format("%B", conn)
  end
end
