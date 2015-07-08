defmodule Plug.AccessLog.DefaultFormatter.QueryStringTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.DefaultFormatter

  test "%q" do
    conn = conn(:get, "/home?query=set")

    assert "?query=set" == DefaultFormatter.format("%q", conn)
  end

  test "%q empty" do
    conn= conn(:get, "/no_query")

    assert "" == DefaultFormatter.format("%q", conn)
  end
end
