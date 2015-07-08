defmodule Plug.AccessLog.DefaultFormatter.RequestCookieTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.DefaultFormatter

  test "%{VARNAME}C" do
    cookie = "TestCookie"
    value  = "test value for %C"

    conn =
         conn(:get, "/")
      |> put_req_cookie(cookie, value)
      |> put_req_cookie(cookie |> String.downcase, value)

    assert value == DefaultFormatter.format("%{#{ cookie }}C", conn)
    assert value == DefaultFormatter.format("%{#{ cookie |> String.downcase }}C", conn)
    assert "-"   == DefaultFormatter.format("%{#{ cookie |> String.upcase }}C", conn)
  end
end
