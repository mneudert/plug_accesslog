defmodule Plug.AccessLog.DefaultFormatter.RemoteUserTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Plug.AccessLog.DefaultFormatter

  test "%u" do
    user = "ex_unit"
    credentials = Base.encode64("#{user}:some_password")

    empty = conn(:get, "/")
    valid = empty |> put_req_header("authorization", "Basic #{credentials}")
    incomplete = empty |> put_req_header("authorization", "Basic #{Base.encode64(user)}")
    garbage = empty |> put_req_header("authorization", "Basic garbage")

    assert "-" == DefaultFormatter.format("%u", empty)
    assert user == DefaultFormatter.format("%u", valid)
    assert "-" == DefaultFormatter.format("%u", incomplete)
    assert "-" == DefaultFormatter.format("%u", garbage)
  end
end
