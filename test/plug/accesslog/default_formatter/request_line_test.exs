defmodule Plug.AccessLog.DefaultFormatter.RequestLineTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.DefaultFormatter

  test "%r" do
    conn = conn(:get, "/plug/path")

    assert "GET /plug/path HTTP/1.1" = DefaultFormatter.format("%r", conn)
  end
end
