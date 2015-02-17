defmodule Plug.AccessLog.Formatter.RequestLineTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.Formatter

  test "%r" do
    conn = conn(:get, "/plug/path")

    assert "GET /plug/path HTTP/1.1" == Formatter.format("%r", conn)
  end
end
