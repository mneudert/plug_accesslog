defmodule Plug.AccessLog.Formatter.QueryStringTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.Formatter

  test "%q" do
    conn = conn(:get, "/home?query=set")

    assert "?query=set" == Formatter.format("%q", conn)
  end

  test "%q empty" do
    conn= conn(:get, "/no_query")

    assert "" == Formatter.format("%q", conn)
  end
end
