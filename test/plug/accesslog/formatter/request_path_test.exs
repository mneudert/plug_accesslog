defmodule Plug.AccessLog.Formatter.RequestPathTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.Formatter

  test "%U" do
    conn = conn(:get, "/plug/path")

    assert "/plug/path" == Formatter.format("%U", conn)
  end
end
