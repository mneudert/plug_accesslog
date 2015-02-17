defmodule Plug.AccessLog.Formatter.RemoteHostnameTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.Formatter

  test "%h" do
    conn = conn(:get, "/")

    assert "127.0.0.1" == Formatter.format("%h", conn)
  end
end
