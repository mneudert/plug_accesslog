defmodule Plug.AccessLog.DefaultFormatter.RequestTimeTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Timex

  alias Plug.AccessLog.DefaultFormatter

  test "%t" do
    timezone = Timex.timezone("America/Chicago", { 2015, 01, 10 })
    datetime = Timex.datetime({{ 2015, 01, 10 }, { 14, 46, 18 }}, timezone)
    conn     =
         conn(:get, "/")
      |> put_private(:plug_accesslog, %{ local_time: datetime })

    assert "[10/Jan/2015:14:46:18 -0600]" == DefaultFormatter.format("%t", conn)
  end
end
