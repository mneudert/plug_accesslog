defmodule Plug.AccessLog.DefaultFormatter.RequestTimeTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Timex

  alias Plug.AccessLog.DefaultFormatter

  test "%t" do
    datetime  = {{ 2015, 01, 10 }, { 14, 46, 18 }}
    conn      =
         conn(:get, "/")
      |> put_private(:plug_accesslog, %{ local_time: datetime })

    formatted =
         datetime
      |> DateTime.from()
      |> Timex.format!("[%d/%b/%Y:%H:%M:%S %z]", :strftime)

    assert formatted == DefaultFormatter.format("%t", conn)
  end
end
