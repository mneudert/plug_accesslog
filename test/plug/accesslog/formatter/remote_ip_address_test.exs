defmodule Plug.AccessLog.Formatter.RemoteIPAddressTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.Formatter

  test "%a" do
    conn = conn(:get, "/")

    assert "127.0.0.1" == Formatter.format("%a", conn)
  end

  test "%h" do
    conn = conn(:get, "/")

    assert "127.0.0.1" == Formatter.format("%h", conn)
  end
end
