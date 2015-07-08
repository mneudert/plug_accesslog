defmodule Plug.AccessLog.FormatterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.Formatter

  test "no format means default format" do
    datetime = :calendar.local_time()
    conn     =
         conn(:get, "/")
      |> put_private(:plug_accesslog, %{ local_time: datetime })

    assert Formatter.format(nil, conn) == Formatter.format(:default, conn)
  end
end
