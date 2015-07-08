defmodule Plug.AccessLog.DefaultFormatter.RemoteIPAddressTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.DefaultFormatter

  test "%a" do
    conn = conn(:get, "/")

    assert "127.0.0.1" == DefaultFormatter.format("%a", conn)
  end

  test "%h" do
    conn = conn(:get, "/")

    assert "127.0.0.1" == DefaultFormatter.format("%h", conn)
  end
end
