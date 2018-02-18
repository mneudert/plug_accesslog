defmodule Plug.AccessLog.FormatterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Timex

  alias Plug.AccessLog.DefaultFormatter
  alias Plug.AccessLog.Formatter

  defmodule CustomFormatter do
    @behaviour Formatter

    def format(_, _), do: "custom"
  end

  defmodule Logfiles do
    def formatter_default do
      [__DIR__, "../../logs/plug_accesslog_formatter_default.log"]
      |> Path.join()
      |> Path.expand()
    end

    def formatter_nil do
      [__DIR__, "../../logs/plug_accesslog_formatter_nil.log"]
      |> Path.join()
      |> Path.expand()
    end

    def formatter_override do
      [__DIR__, "../../logs/plug_accesslog_formatter_override.log"]
      |> Path.join()
      |> Path.expand()
    end
  end

  defmodule Router do
    use Plug.Router

    plug Plug.AccessLog,
      format: "%U",
      file: Logfiles.formatter_default()

    plug Plug.AccessLog,
      format: "%U",
      formatters: [],
      file: Logfiles.formatter_nil()

    plug Plug.AccessLog,
      format: "%U",
      formatters: [CustomFormatter, DefaultFormatter],
      file: Logfiles.formatter_override()

    plug :match
    plug :dispatch

    get "/format_me", do: send_resp(conn, 200, "OK")
  end

  test "no format means default format" do
    datetime = Timex.local()

    conn =
      conn(:get, "/")
      |> put_private(:plug_accesslog, %{local_time: datetime})

    msg_def = Formatter.format(:default, conn, nil)
    msg_nil = Formatter.format(nil, conn, nil)

    assert msg_def == msg_nil
  end

  test "formatter pipeline" do
    conn(:get, "/format_me") |> Router.call([])

    :timer.sleep(50)

    assert "/format_me" == Logfiles.formatter_default() |> File.read!() |> String.trim()
    assert "%U" == Logfiles.formatter_nil() |> File.read!() |> String.trim()
    assert "custom" == Logfiles.formatter_override() |> File.read!() |> String.trim()
  end
end
