defmodule Plug.AccessLog.Formatter.RemoteUserTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.Formatter

  test "%u" do
    user        = "ex_unit"
    credentials = Base.encode64("#{ user }:some_password")

    empty      = conn(:get, "/")
    valid      = empty |> put_req_header("Authorization", "Basic #{ credentials }")
    incomplete = empty |> put_req_header("Authorization", "Basic #{ Base.encode64(user) }")
    garbage    = empty |> put_req_header("Authorization", "Basic garbage")

    assert "-"  == Formatter.format("%u", empty)
    assert user == Formatter.format("%u", valid)
    assert "-"  == Formatter.format("%u", incomplete)
    assert "-"  == Formatter.format("%u", garbage)
  end
end
