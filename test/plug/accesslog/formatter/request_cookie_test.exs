defmodule Plug.AccessLog.Formatter.RequestCookieTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.Formatter

  test "%{VARNAME}C" do
    cookie = "TestCookie"
    value  = "test value for %C"

    conn =
         conn(:get, "/")
      |> put_req_cookie(cookie, value)
      |> put_req_cookie(cookie |> String.downcase, value)

    assert value == Formatter.format("%{#{ cookie }}C", conn)
    assert value == Formatter.format("%{#{ cookie |> String.downcase }}C", conn)
    assert "-"   == Formatter.format("%{#{ cookie |> String.upcase }}C", conn)
  end
end
