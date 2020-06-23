defmodule Plug.AccessLog.DefaultFormatter.RequestCookieTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.DefaultFormatter

  test "%{VARNAME}C" do
    cookie = "TestCookie"
    value = "test value for %C"

    conn =
      conn(:get, "/")
      |> put_req_cookie(cookie, value)
      |> put_req_cookie(String.downcase(cookie), value)

    assert ^value = DefaultFormatter.format("%{#{cookie}}C", conn)
    assert ^value = DefaultFormatter.format("%{#{String.downcase(cookie)}}C", conn)
    assert "-" = DefaultFormatter.format("%{#{String.upcase(cookie)}}C", conn)
  end
end
