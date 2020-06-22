defmodule Plug.AccessLog.DefaultFormatter.RequestPathTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.DefaultFormatter

  test "%U" do
    conn = conn(:get, "/plug/path")

    assert "/plug/path" = DefaultFormatter.format("%U", conn)
  end
end
