defmodule Plug.AccessLog.Formatter.RequestTimeTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Timex

  alias Plug.AccessLog.Formatter

  test "%t" do
    datetime  = {{ 2015, 01, 10 }, { 14, 46, 18 }}
    conn      = conn(:get, "/") |> put_private(:plug_accesslog, datetime)
    formatted =
         datetime
      |> Date.from(:local)
      |> DateFormat.format!("[%d/%b/%Y:%H:%M:%S %z]", :strftime)

    assert formatted == Formatter.format("%t", conn)
  end
end
