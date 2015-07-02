defmodule Plug.AccessLog.Formatter.RequestServingTimeTest do
  use ExUnit.Case, async: true
  use Plug.Test

  use Timex

  alias Plug.AccessLog.Formatter

  test "%M" do
    timestamp = :os.timestamp()
    conn      =
         conn(:get, "/")
      |> put_private(:plug_accesslog, %{ timestamp: timestamp })

    # relying on millisecond testing precision is flaky.
    # check done using "milliseconds taken < 1 second"
    { msecs, _ } = Formatter.format("%M", conn) |> Integer.parse()

    assert msecs < 1000
  end

  test "%T" do
    timestamp = :os.timestamp()
    conn      =
         conn(:get, "/")
      |> put_private(:plug_accesslog, %{ timestamp: timestamp })

    assert "0" == Formatter.format("%T", conn)
  end

  test "%T rounding" do
    timestamp = :os.timestamp() |> Time.sub({ 0, 0, 750000 })
    conn      =
         conn(:get, "/")
      |> put_private(:plug_accesslog, %{ timestamp: timestamp })

    assert "1" == Formatter.format("%T", conn)
  end
end
