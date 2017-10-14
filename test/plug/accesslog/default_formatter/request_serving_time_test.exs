defmodule Plug.AccessLog.DefaultFormatter.RequestServingTimeTest do
  use ExUnit.Case, async: true
  use Plug.Test

  use Timex

  alias Plug.AccessLog.DefaultFormatter

  test "%D == %{us}T" do
    timestamp = :os.timestamp()

    conn =
      conn(:get, "/")
      |> put_private(:plug_accesslog, %{timestamp: timestamp})

    # relying on microsecond testing precision is flaky.
    # check done using "microseconds taken < 1 second"
    {usecs, _} = DefaultFormatter.format("%D", conn) |> Integer.parse()
    {t_var, _} = DefaultFormatter.format("%{us}T", conn) |> Integer.parse()

    assert usecs < 1_000_000
    assert t_var < 1_000_000
  end

  test "%M == %{ms}T" do
    timestamp = :os.timestamp()

    conn =
      conn(:get, "/")
      |> put_private(:plug_accesslog, %{timestamp: timestamp})

    # relying on millisecond testing precision is flaky.
    # check done using "milliseconds taken < 1 second"
    {msecs, _} = DefaultFormatter.format("%M", conn) |> Integer.parse()
    {t_var, _} = DefaultFormatter.format("%{ms}T", conn) |> Integer.parse()

    assert msecs < 1000
    assert t_var < 1000
  end

  test "%T == %{s}T" do
    timestamp = :os.timestamp()

    conn =
      conn(:get, "/")
      |> put_private(:plug_accesslog, %{timestamp: timestamp})

    assert "0" == DefaultFormatter.format("%T", conn)
    assert "0" == DefaultFormatter.format("%{s}T", conn)
  end

  test "%T rounding" do
    subtract = Duration.from_seconds(1)
    timestamp = Duration.now() |> Duration.diff(subtract) |> Duration.to_erl()

    conn =
      conn(:get, "/")
      |> put_private(:plug_accesslog, %{timestamp: timestamp})

    assert "1" == DefaultFormatter.format("%T", conn)
    assert "1" == DefaultFormatter.format("%{s}T", conn)
  end
end
